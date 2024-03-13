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
import SearchTextField

//TODO: - 복용약 이름이 제대로 설정되지 않았을 때, Timer를 통해서 메세지 알리기 - Toast로 해결
//TODO: - 의약품 일련번호, 이름 DB Migration 해야됨
//TODO: - 의약품 허가 목록에 이미지파일 있음. 현재 itemSeq으로 다시 호출하여 검색하는데, 추후 버전 업데이트시 변경 해야 됨
final class RegisterPillViewController : BaseViewController {
    
    private let mainView = RegisterPillView()
    private var viewModel = RegisterPillViewModel()
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
            if let criteria = mainView.userInputTextfield.text {
                
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
                    
                    // Trigger
                    viewModel.callRequestForItemListTrigger.value = whipeSpaceRemovedText
                    
                    viewModel.outputItemEntpNameSeqList.bind { [weak self] value in
                        guard let self = self else { return }
                        guard let value = value else { return }
                        
                        let convertItemEntpNameList = value.map { value in
                            let tempItemName = value.itemName.regxRemove(regString: "(수출명")
                            let resultItemName = tempItemName.regxRemove(regString: "[수출명")
                            
                            return SearchTextFieldItem(title: resultItemName, subtitle: value.entpName)
                        }
                        
                        mainView.userInputTextfield.filterItems(convertItemEntpNameList)
                        mainView.userInputTextfield.stopLoadingIndicator()
                    }
                }
            }
        }
        
        // autocomplete이 선택되었을 때
        mainView.userInputTextfield.itemSelectionHandler = { [weak self] item, itemPosition in
            guard let self = self else { return }
            guard let outputItemEntpNameSeqList = viewModel.outputItemEntpNameSeqList.value else { return }
            
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                mainView.endEditing(true)
            }
            
            mainView.setActivityIndicator()
            
            mainView.userInputTextfield.text = item[itemPosition].title
            viewModel.inputItemName.value = item[itemPosition].title
            viewModel.inputItemSeq.value = outputItemEntpNameSeqList[itemPosition].itemSeq
            viewModel.inputEntpName.value = outputItemEntpNameSeqList[itemPosition].entpName
            viewModel.inputEntpNo.value = outputItemEntpNameSeqList[itemPosition].entpNo
            
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
//        kfCacheClear()
        dismiss(animated: true)
    }
    
    func completePillRegister() {
        
        //TODO: - Databse에 데이터 넣어야 됨
        viewModel.pillRegister { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success:
                pillListDelegate?.completeToast()
//                kfCacheClear()
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
                guard let itemSeq = viewModel.inputItemSeq.value else { return }
                
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
        mainView.pillImageView.kf.setImage(with: provider, options: [.transition(.fade(1)), .forceRefresh])
    }
    
    private func kfCacheClear() {
        let cache = ImageCache.default
        cache.cleanExpiredMemoryCache()
    }
    
}

extension RegisterPillViewController : UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        print(#function)
        textField.text = nil
        mainView.userInputTextfield.filterStrings([])
        mainView.addImageTitleLabel.isHidden = true
        mainView.addImageTitleLabel.isHidden = true
        mainView.buttonStackView.isHidden = true
        mainView.pillImageView.isHidden = true
        mainView.completeButton.isHidden = true
        mainView.pillImageView.image = nil
    }
    
}
