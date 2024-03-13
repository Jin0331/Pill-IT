//
//  RegisterPill.swift
//  Pill-IT
//
//  Created by JinwooLee on 3/7/24.
//

import UIKit
import Toast_Swift
import Kingfisher
import YPImagePicker

//TODO: - 복용약 이름이 제대로 설정되지 않았을 때, Timer를 통해서 메세지 알리기 - Toast로 해결
//TODO: - 의약품 일련번호, 이름 DB Migration 해야됨
final class RegisterPillViewController : BaseViewController {
    
    let mainView = RegisterPillView()
    var viewModel = RegisterPillViewModel()
    weak var pillListDelegate : PillListAction?

    override func loadView() {
        self.view = mainView
        mainView.actionDelegate = self
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bindData()
    }
    
    private func bindData() {
        textFieldHandler()
    }
    
    override func configureView() {
        mainView.userInputTextfield.delegate = self
    }
    
    private func textFieldHandler() {
        // 2글자 이상 입력될때 실행되도록
        mainView.userInputTextfield.userStoppedTypingHandler = { [weak self] in
            guard let self = self else { return }
            if let criteria = self.mainView.userInputTextfield.text {
                
                let whipeSpaceRemovedText = criteria.replacingOccurrences(of: " ", with: "")
                print(whipeSpaceRemovedText)
                
                if !whipeSpaceRemovedText.isHangul {
                    view.makeToast("한글 검색만 지원됩니다❗️", duration: 1.0, position: .center)
                    return
                }
                
                if whipeSpaceRemovedText.count >= 2 {
                    
                    DispatchQueue.main.async { [weak self] in
                        guard let self = self else { return }
                        mainView.endEditing(true)
                    }
                    
                    mainView.userInputTextfield.showLoadingIndicator()
                    
                    viewModel.callRequestForItemListTrigger.value = whipeSpaceRemovedText
                    viewModel.outputItemNameList.bind { [weak self] value in
                        guard let self = self else { return }
                        guard let value = value else {
                            return
                        }
                        
                        let convertValue = value.map {
                            let temp = $0.regxRemove(regString: "(수출명")
                            let result = temp.regxRemove(regString: "[수출명")
                            
                            return result
                        }
                        
                        mainView.userInputTextfield.filterStrings(convertValue)
                        mainView.userInputTextfield.stopLoadingIndicator()
                    }
                }
            }
        }
        
        // autocomplete이 선택되었을 때
        mainView.userInputTextfield.itemSelectionHandler = { [weak self] item, itemPosition in
            guard let self = self else { return }
            guard let outputItemNameSeqList = self.viewModel.outputItemNameSeqList.value else { return }
            
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                mainView.endEditing(true)
            }
            
            mainView.setActivityIndicator()
            
            mainView.userInputTextfield.text = item[itemPosition].title
            viewModel.inputItemName.value = item[itemPosition].title
            viewModel.inputItemSeq.value = outputItemNameSeqList[itemPosition]
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.5, qos: .background) { [weak self] in
                
                guard let self = self else { return }
                
                // 커서 맨 앞으로 옮기기
                mainView.userInputTextfield.selectedTextRange = mainView.userInputTextfield.textRange(from: mainView.userInputTextfield.beginningOfDocument, to: mainView.userInputTextfield.beginningOfDocument)
                
                // 기존 autucomplete 삭제
                mainView.userInputTextfield.filterItems([])
                
                
                // 이미지 등록하기 true
                //TODO: -시간되면 Animation 넣기
                mainView.addImageTitleLabel.isHidden = false
                mainView.buttonStackView.isHidden = false
                
                // loading
                mainView.activityIndicator.stopAnimating()
                mainView.loadingBgView.removeFromSuperview()
                
                view.makeToast("약에 대한 검색이 완료되었어요 ✅", duration: 1.0, position: .center)
            }
        }
    }
        
    deinit {
        print(#function, " - ✅ RegisterPillView")
    }
}


//MARK: - View Action Protocol
extension RegisterPillViewController : PillRegisterAction {
    
    func disMissPresent() {
        dismiss(animated: true)
    }
    
    func completePillRegister() {
        
        //TODO: - Databse에 데이터 넣어야 됨
        viewModel.pillRegister { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success:
                pillListDelegate?.completeToast()
                dismiss(animated: true)
            case .failure:
                view.makeToast("이미 등록된 복용약입니다 😓", duration: 1.5, position: .center)
            }
        }
    }
    
    func defaultButtonAction() {
        
        self.mainView.setActivityIndicator()
        
        viewModel.callcallRequestForImageTrigger.value = viewModel.inputItemSeq.value
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.7, qos: .background) { [weak self] in
            
            guard let self = self else { return }
            
            guard let defaultImage = self.viewModel.localImageURL.value else {
                view.makeToast("식품의약처에 등록된 이미지가 없습니다 🥲", duration: 3.0, position: .center)
                mainView.activityIndicator.stopAnimating()
                mainView.loadingBgView.removeFromSuperview()
                
                return
            }
            
            mainView.pillImageView.isHidden = false
            getLocalImage(imagePath: defaultImage)
            mainView.completeButton.isHidden = false
            
            mainView.activityIndicator.stopAnimating()
            mainView.loadingBgView.removeFromSuperview()

            view.makeToast("이미지를 불러왔어요 ✅", duration: 1.5, position: .center)
        }
    }
    
    func cameraGalleryButtonAction() {
        var config = YPImagePickerConfiguration()
        config.shouldSaveNewPicturesToAlbum = true // YPImagePicker의 카메라로 찍은 사진 핸드폰에 저장하기
        config.showsPhotoFilters = false
        let picker = YPImagePicker(configuration: config)
        
        picker.didFinishPicking { [weak self] items, cancelled in
            guard let self = self else { return }

            if cancelled {
                view.makeToast("이미지 촬영 또는 선택이 취소되었습니다 🥲", duration: 2.0, position: .center)
            }

            if let photo = items.singlePhoto {
                guard let itemSeq = self.viewModel.inputItemSeq.value else { return }
                
                FileDownloadManager.shared.saveLocalImage(image: photo.image, pillID: itemSeq) { [weak self] value in
                    guard let self = self else { return }
                    
                    switch value {
                    case .success(let result):
                        viewModel.localImageURL.value = result.path
                        
                        mainView.pillImageView.isHidden = false
                        getLocalImage(imagePath: result.path)
                        mainView.completeButton.isHidden = false // complete 활성화
                        
                        view.makeToast("이미지를 불러왔어요 ✅", duration: 2.0, position: .center)
                    case .failure(let error):
                        print(error)
                    }
                }
            }
            picker.dismiss(animated: true)
        }
        present(picker, animated: true, completion: nil)
    }
    
    func webSearchButtonAction() {
        
        viewModel.callcallRequestForWebTrigger.value = nil
        
        let vc = RegisterPillWebSearchViewController()
        vc.viewModel = viewModel
        vc.sendData = { [weak self] webURL in
            print(webURL)
            DispatchQueue.main.async { [weak self] in
                
                guard let self = self else { return }
                
                viewModel.localImageURL.value = webURL.path
                mainView.pillImageView.isHidden = false
                getLocalImage(imagePath: webURL.path)
                mainView.completeButton.isHidden = false
                view.makeToast("이미지를 불러왔어요 ✅", duration: 2.0, position: .center)
            }
        }
        
        present(vc, animated: true)
    }
    
    private func getLocalImage(imagePath : String) {
        let url = URL(fileURLWithPath: imagePath)
        let provider = LocalFileImageDataProvider(fileURL: url)
        self.mainView.pillImageView.kf.setImage(with: provider, options: [.transition(.fade(1)), .forceRefresh])
    }
    
}

extension RegisterPillViewController : UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        print(#function)
        textField.text = nil
        self.mainView.userInputTextfield.filterStrings([])
        self.mainView.addImageTitleLabel.isHidden = true
        self.mainView.addImageTitleLabel.isHidden = true
        self.mainView.buttonStackView.isHidden = true
        self.mainView.pillImageView.isHidden = true
        self.mainView.completeButton.isHidden = true
        self.mainView.pillImageView.image = nil
    }
    
}
