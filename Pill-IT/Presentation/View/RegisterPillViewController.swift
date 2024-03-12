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
                    self.view.makeToast("한글 검색만 지원됩니다❗️", duration: 1.0, position: .center)
                    return
                }
                
                if whipeSpaceRemovedText.count >= 2 {
                    self.mainView.userInputTextfield.showLoadingIndicator()
                    
                    self.viewModel.callRequestForItemListTrigger.value = whipeSpaceRemovedText
                    self.viewModel.outputItemNameList.bind { [weak self] value in
                        guard let self = self else { return }
                        guard let value = value else {
                            return
                        }
                        
                        let convertValue = value.map {
                            var temp = $0.regxRemove(regString: "(수출명")
                            var result = temp.regxRemove(regString: "[수출명")
                            
                            return result
                        }
                        
                        self.mainView.userInputTextfield.filterStrings(convertValue)
                        self.mainView.userInputTextfield.stopLoadingIndicator()
                    }
                }
            }
        }
        
        // autocomplete이 선택되었을 때
        mainView.userInputTextfield.itemSelectionHandler = { [weak self] item, itemPosition in
            guard let self = self else { return }
            guard let outputItemNameSeqList = self.viewModel.outputItemNameSeqList.value else { return }
            
            DispatchQueue.main.async {
                self.mainView.endEditing(true)
            }
            
            self.mainView.setActivityIndicator()
            
            self.mainView.userInputTextfield.text = item[itemPosition].title
            self.viewModel.inputeItemName.value = item[itemPosition].title
            self.viewModel.inputItemSeq.value = outputItemNameSeqList[itemPosition]
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5, qos: .background) {
                
                // 커서 맨 앞으로 옮기기
                self.mainView.userInputTextfield.selectedTextRange = self.mainView.userInputTextfield.textRange(from: self.mainView.userInputTextfield.beginningOfDocument, to: self.mainView.userInputTextfield.beginningOfDocument)
                
                // 기존 autucomplete 삭제
                self.mainView.userInputTextfield.filterItems([])
                
                
                // 이미지 등록하기 true
                //TODO: -시간되면 Animation 넣기
                
                self.mainView.addImageTitleLabel.isHidden = false
                self.mainView.buttonStackView.isHidden = false
                
                // loading
                self.mainView.activityIndicator.stopAnimating()
                self.mainView.loadingBgView.removeFromSuperview()
                
                self.view.makeToast("약에 대한 검색이 완료되었어요 ✅", duration: 1.0, position: .center)
            }
        }
    }
        
    deinit {
        print(#function, " - RegisterPillView")
    }
}


//MARK: - View Action Protocol
extension RegisterPillViewController : RegisterPillAction {
    
    func disMissPresent() {
        dismiss(animated: true)
    }
    
    func completePillRegister() {
        
        //TODO: - Databse에 데이터 넣어야 됨
        dismiss(animated: true)
    }
    
    func defaultButtonAction() {
        
        self.view.makeToast("잠시만 기다려주세요 😓", duration: 1.0, position: .center)
        
        viewModel.callcallRequestForImageTrigger.value = viewModel.inputItemSeq.value
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.7, qos: .background) {
            
            guard let defaultImage = self.viewModel.localImageURL.value else {
                self.view.makeToast("식품의약처에 등록된 이미지가 없습니다 🥲", duration: 3.0, position: .center)
                return
            }
            
            self.mainView.pillImageView.isHidden = false
            self.getLocalImage(imagePath: defaultImage)
            self.mainView.completeButton.isHidden = false
            
            self.view.makeToast("이미지를 불러왔어요 ✅", duration: 3.0, position: .center)
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
                self.view.makeToast("이미지 촬영 또는 선택이 취소되었습니다 🥲", duration: 3.0, position: .center)
            }

            if let photo = items.singlePhoto {
                guard let itemSeq = self.viewModel.inputItemSeq.value else { return }
                
                FileDownloadManager.shared.saveLocalImage(image: photo.image, pillID: itemSeq) { [weak self] value in
                    guard let self = self else { return }
                    
                    switch value {
                    case .success(let result):
                        self.viewModel.localImageURL.value = result.path
                        
                        self.mainView.pillImageView.isHidden = false
                        self.getLocalImage(imagePath: result.path)
                        self.mainView.completeButton.isHidden = false // complete 활성화
                        
                        self.view.makeToast("이미지를 불러왔어요 ✅", duration: 3.0, position: .center)
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
        vc.sendData = { webURL in
            print(webURL)
            DispatchQueue.main.async {
                self.viewModel.localImageURL.value = webURL.path
                self.mainView.pillImageView.isHidden = false
                self.getLocalImage(imagePath: webURL.path)
                self.mainView.completeButton.isHidden = false
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
        textField.text = ""
        self.mainView.userInputTextfield.filterStrings([])
        self.mainView.addImageTitleLabel.isHidden = true
        self.mainView.addImageTitleLabel.isHidden = true
        self.mainView.buttonStackView.isHidden = true
        self.mainView.pillImageView.isHidden = true
        self.mainView.pillImageView.image = nil
    }
    
}
