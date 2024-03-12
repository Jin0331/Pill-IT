//
//  RegisterPillView.swift
//  Pill-IT
//
//  Created by JinwooLee on 3/10/24.
//

import UIKit
import SnapKit
import Then
import SearchTextField
import Kingfisher
import NVActivityIndicatorView

class RegisterPillView: BaseView {
    
    weak var actionDelegate : RegisterPillAction?
    
    let exitButton = UIButton().then {
        $0.setImage(DesignSystem.iconImage.clear, for: .normal)
        $0.tintColor = DesignSystem.colorSet.black
    }
    
    let titleLabel = UILabel().then {
        $0.text = "복용약 등록"
        $0.textColor = DesignSystem.colorSet.black
        $0.font = .systemFont(ofSize: 40, weight: .heavy)
    }
    
    let userInputTextfield = SearchTextField().then {
        $0.attributedPlaceholder = NSAttributedString(string: "복용중인 약을 입력해주세요", attributes: [NSAttributedString.Key.foregroundColor : DesignSystem.colorSet.lightBlack])
        $0.addLeftPadding()
        $0.clearButtonMode = .always
        $0.font = .systemFont(ofSize: 23, weight: .heavy)
        $0.textColor = DesignSystem.colorSet.black
        $0.layer.borderWidth = DesignSystem.viewLayout.borderWidth
        $0.layer.borderColor = DesignSystem.colorSet.lightBlack.cgColor
        $0.layer.cornerRadius = DesignSystem.viewLayout.cornerRadius
        
        
        $0.theme.font = .systemFont(ofSize: 15)
        $0.highlightAttributes = [NSAttributedString.Key.backgroundColor: DesignSystem.colorSet.lightGray, NSAttributedString.Key.font:UIFont.systemFont(ofSize: 15, weight: .heavy),
                                  NSAttributedString.Key.foregroundColor : DesignSystem.colorSet.purple.cgColor]
        $0.theme.bgColor = DesignSystem.colorSet.lightGray
        $0.theme.borderColor = DesignSystem.colorSet.lightBlack
        $0.theme.borderWidth = DesignSystem.viewLayout.borderWidth
        $0.theme.cellHeight = 50
        $0.forceNoFiltering = false
        $0.minCharactersNumberToStartFiltering = 2
        $0.comparisonOptions = [.caseInsensitive]
        $0.hideResultsList()
    }
    
    let addImageTitleLabel = UILabel().then {
        $0.text = "이미지 등록하기"
        $0.textColor = DesignSystem.colorSet.gray
        $0.font = .systemFont(ofSize: 18, weight: .heavy)
        $0.isHidden = true
    }
    
    let buttonStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.distribution = .fillEqually
        $0.spacing = 10
        $0.isHidden = true
    }
    
    let defaultButton = UIButton(type: .system).then{
        $0.setTitle("식약처", for: .normal)
        $0.setTitleColor(DesignSystem.colorSet.lightBlack, for: .normal)
        $0.titleLabel?.font = .systemFont(ofSize: 20, weight: .heavy)
        $0.layer.borderWidth = DesignSystem.viewLayout.borderWidth
        $0.layer.borderColor = DesignSystem.colorSet.lightBlack.cgColor
        $0.layer.cornerRadius = DesignSystem.viewLayout.cornerRadius
    }
    
    let cameraGalleryButton = UIButton(type: .system).then{
        $0.setTitle("카메라", for: .normal)
        $0.setTitleColor(DesignSystem.colorSet.lightBlack, for: .normal)
        $0.titleLabel?.font = .systemFont(ofSize: 20, weight: .heavy)
        $0.layer.borderWidth = DesignSystem.viewLayout.borderWidth
        $0.layer.borderColor = DesignSystem.colorSet.lightBlack.cgColor
        $0.layer.cornerRadius = DesignSystem.viewLayout.cornerRadius
    }
    
    let webSearchButton = UIButton(type: .system).then{
        $0.setTitle("WEB", for: .normal)
        $0.setTitleColor(DesignSystem.colorSet.lightBlack, for: .normal)
        $0.titleLabel?.font = .systemFont(ofSize: 20, weight: .heavy)
        $0.layer.borderWidth = DesignSystem.viewLayout.borderWidth
        $0.layer.borderColor = DesignSystem.colorSet.lightBlack.cgColor
        $0.layer.cornerRadius = DesignSystem.viewLayout.cornerRadius
    }

    let pillImageView = UIImageView().then {
        $0.backgroundColor = DesignSystem.colorSet.white
        $0.layer.borderWidth = DesignSystem.viewLayout.borderWidth
        $0.layer.borderColor = DesignSystem.colorSet.lightBlack.cgColor
        $0.layer.cornerRadius = DesignSystem.viewLayout.cornerRadius
        $0.isHidden = true
    }
    
    let completeButton = UIButton().then {
        $0.setTitle("복용약 등록 🥰", for: .normal)
        $0.setTitleColor(DesignSystem.colorSet.white, for: .normal)
        $0.titleLabel?.font = .systemFont(ofSize: 23, weight: .heavy)
        $0.backgroundColor = DesignSystem.colorSet.lightBlack
        $0.layer.cornerRadius = DesignSystem.viewLayout.cornerRadius
        $0.isHidden = true
    }
    
    // Loading
    lazy var loadingBgView: UIView = {
        let bgView = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height))
        bgView.backgroundColor = .clear
        
        return bgView
    }()
    
    lazy var activityIndicator: NVActivityIndicatorView = {
        let activityIndicator = NVActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 40, height: 40),
                                                        type: .circleStrokeSpin,
                                                        color: DesignSystem.colorSet.lightBlack,
                                                        padding: .zero)
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        
        return activityIndicator
    }()
    
    
    override func configureHierarchy() {
        // main
        [exitButton,titleLabel,userInputTextfield,addImageTitleLabel,buttonStackView,pillImageView,completeButton].forEach { addSubview($0) }
        
        // buttonStackView
        [defaultButton, cameraGalleryButton, webSearchButton].forEach { buttonStackView.addArrangedSubview($0) }
    }
    
    override func configureLayout() {
        
        exitButton.snp.makeConstraints { make in
            make.top.leading.equalToSuperview().inset(20)
            make.size.equalTo(40)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(exitButton.snp.bottom).offset(10)
            make.horizontalEdges.equalToSuperview().inset(20)
            make.height.equalTo(50)
        }
        
        userInputTextfield.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(20)
            make.horizontalEdges.equalTo(titleLabel)
            make.height.equalTo(70)
        }
        
        addImageTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(userInputTextfield.snp.bottom).offset(40)
            make.horizontalEdges.equalToSuperview().inset(20)
        }
        
        buttonStackView.snp.makeConstraints { make in
            make.top.equalTo(addImageTitleLabel.snp.bottom).offset(10)
            make.horizontalEdges.equalTo(addImageTitleLabel)
            make.height.equalTo(50)
        }
        
        pillImageView.snp.makeConstraints { make in
            make.top.equalTo(buttonStackView.snp.bottom).offset(20)
            make.centerX.equalTo(userInputTextfield)
            make.width.equalTo(userInputTextfield)
            make.height.equalTo(230)
        }
        
        completeButton.snp.makeConstraints { make in
            make.top.equalTo(pillImageView.snp.bottom).offset(20)
            make.horizontalEdges.equalTo(pillImageView)
            make.height.equalTo(userInputTextfield)
        }
    }
    
    override func configureView() {
        super.configureView()
        
        exitButton.addTarget(self, action: #selector(exitButtonClicked), for: .touchUpInside)
        completeButton.addTarget(self, action: #selector(completeButtonClicked), for: .touchUpInside)
        
        defaultButton.addTarget(self, action: #selector(defaultButtonClicked), for: .touchUpInside)
        cameraGalleryButton.addTarget(self, action: #selector(cameraGalleryButtonClicked), for: .touchUpInside)
        webSearchButton.addTarget(self, action: #selector(webSearchButtonClicked), for: .touchUpInside)
    }
    
    @objc func exitButtonClicked() {
        print(#function)
        actionDelegate?.disMissPresent()
    }
    
    @objc func completeButtonClicked() {
        print(#function)
        actionDelegate?.completePillRegister()
    }
    
    @objc func defaultButtonClicked() {
        print(#function)
        actionDelegate?.defaultButtonAction()
    }
    
    @objc func cameraGalleryButtonClicked() {
        print(#function)
        actionDelegate?.cameraGalleryButtonAction()
    }
    
    @objc func webSearchButtonClicked() {
        print(#function)
        actionDelegate?.webSearchButtonAction()
    }
    
    func setActivityIndicator() {
        // 불투명 뷰 추가
        addSubview(loadingBgView)
        // activity indicator 추가
        loadingBgView.addSubview(activityIndicator)
        
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
        
        // 애니메이션 시작
        activityIndicator.startAnimating()
    }
    
    deinit {
        print(#function, " - ✅ RegisterPillView in-Side")
    }
    
}
