//
//  RegisterPill.swift
//  Pill-IT
//
//  Created by JinwooLee on 3/7/24.
//

import UIKit
import Toast_Swift
import Kingfisher

//TODO: - 복용약 이름이 제대로 설정되지 않았을 때, Timer를 통해서 메세지 알리기

class RegisterPillViewController : BaseViewController {
    
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
                
                if whipeSpaceRemovedText.count >= 2 {
                    self.mainView.userInputTextfield.showLoadingIndicator()
                    
                    self.viewModel.callRequestForItemListTrigger.value = whipeSpaceRemovedText
                    self.viewModel.outputItemNameList.bind { [weak self] value in
                        guard let self = self else { return }
                        guard let value = value else { print("wrong text!");return }
                        
                        self.mainView.userInputTextfield.filterStrings(value)
                        self.mainView.userInputTextfield.stopLoadingIndicator()
                    }
                }
            }
        }
        
        // autocomplete이 선택되었을 때
        mainView.userInputTextfield.itemSelectionHandler = { [weak self] item, itemPosition in
            guard let self = self else { return }
            guard let outputItemNameSeqList = self.viewModel.outputItemNameSeqList.value else { return }
            
            self.mainView.endEditing(true)
            self.mainView.setActivityIndicator()
            
            self.mainView.userInputTextfield.text = item[itemPosition].title
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
                
                self.view.makeToast("약에 대한 검색이 완료되었어요 ✅", duration: 3.0, position: .center)
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
        guard let defaultImage = self.viewModel.outputLocalImageURL.value else {
            self.view.makeToast("식품의약처에 등록된 이미지가 없습니다 🥲", duration: 3.0, position: .center)
            return
        }
        
        self.mainView.pillImageView.isHidden = false
        let url = URL(fileURLWithPath: defaultImage)
        let provider = LocalFileImageDataProvider(fileURL: url)
        self.mainView.pillImageView.kf.setImage(with: provider, options: [.transition(.fade(1))])
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.2) {
            self.mainView.completeButton.isHidden = false
        }
    }
    
    func cameraGalleryButtonAction() {
        
    }
    
    func webSearchButtonAction() {
        
    }
    
    
}

extension RegisterPillViewController :  UITextFieldDelegate {
    
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
