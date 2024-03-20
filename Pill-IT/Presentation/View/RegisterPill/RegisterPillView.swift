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

//TODO: - scrollview 적용해야됨 for iPhone SE

final class RegisterPillView: BaseView {
    
    weak var actionDelegate : PillRegisterAction?
     
//    
//    let titleLabel = UILabel().then {
//        $0.text = "🌟 복용약 등록하기"
//        $0.textColor = DesignSystem.colorSet.black
//        $0.font = .systemFont(ofSize: 28, weight: .heavy)
//        $0.layer.shadowOffset = CGSize(width: 10, height: 5)
//        $0.layer.shadowOpacity = 0.4
//        $0.layer.shadowRadius = 10
//        $0.layer.masksToBounds = false
//    }
    
    let userInputTextfield = SearchTextField().then {
        $0.attributedPlaceholder = NSAttributedString(string: "복용중인 약을 입력해주세요", attributes: [NSAttributedString.Key.foregroundColor : DesignSystem.colorSet.gray])
        $0.addLeftPadding()
        $0.clearButtonMode = .whileEditing
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
    
    let scrollView = UIScrollView().then {
        $0.backgroundColor = DesignSystem.colorSet.white
        $0.isScrollEnabled = true
        $0.showsVerticalScrollIndicator = true
        $0.bounces = false
    }
    
    let contentsView = UIView().then {
        $0.backgroundColor = DesignSystem.colorSet.white
    }
    
    let addImageTitleLabel = UILabel().then {
        $0.text = "이미지 등록하기"
        $0.textColor = DesignSystem.colorSet.lightBlack
        $0.font = .systemFont(ofSize: 18, weight: .heavy)
        $0.isHidden = true
    }
    
    let defaultImageButton = UIButton().then {
        $0.setTitle("기본 이미지 불러오기", for: .normal)
        $0.setTitleColor(DesignSystem.colorSet.gray, for: .normal)
        $0.titleLabel?.font = .systemFont(ofSize: 15, weight: .bold)
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
        $0.layer.cornerRadius = DesignSystem.viewLayout.imageCornetRadius
        $0.clipsToBounds = true        
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
        let activityIndicator = NVActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 60, height: 60),
                                                        type: .ballPulseSync,
                                                        color: DesignSystem.colorSet.red,
                                                        padding: .zero)
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        
        return activityIndicator
    }()
    
    
    override func configureHierarchy() {
        // main
        [userInputTextfield, scrollView].forEach { addSubview($0) }
        
        // scroll view
        scrollView.addSubview(contentsView)
        [addImageTitleLabel,defaultImageButton,buttonStackView,pillImageView,completeButton].forEach { contentsView.addSubview($0) }
        
        // buttonStackView
        [defaultButton, cameraGalleryButton, webSearchButton].forEach { buttonStackView.addArrangedSubview($0) }
    }
    
    override func configureLayout() {
        userInputTextfield.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide).inset(20)
            make.horizontalEdges.equalToSuperview().inset(20)
            make.height.equalTo(70)
        }
        
        scrollView.snp.makeConstraints {
            $0.top.equalTo(userInputTextfield.snp.bottom).offset(40)
            $0.horizontalEdges.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
        
        contentsView.snp.makeConstraints {
            $0.width.equalToSuperview()
            $0.top.bottom.equalToSuperview()
        }
        
        addImageTitleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.equalTo(userInputTextfield)
            make.width.equalTo(userInputTextfield).multipliedBy(0.4)
        }
        
        defaultImageButton.snp.makeConstraints { make in
            make.top.equalTo(addImageTitleLabel)
            make.trailing.equalTo(userInputTextfield)
            make.width.equalTo(userInputTextfield).multipliedBy(0.4)
            make.centerY.equalTo(addImageTitleLabel)
        }
        
        buttonStackView.snp.makeConstraints { make in
            make.top.equalTo(addImageTitleLabel.snp.bottom).offset(10)
            make.horizontalEdges.equalTo(userInputTextfield)
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
            make.bottom.equalToSuperview().inset(20)
        }
    }
    
    override func configureView() {
        super.configureView()
        
        completeButton.addTarget(self, action: #selector(completeButtonClicked), for: .touchUpInside)
        defaultImageButton.addTarget(self, action: #selector(defaultImageButtonClicked), for: .touchUpInside)
        
        defaultButton.addTarget(self, action: #selector(defaultButtonClicked), for: .touchUpInside)
        cameraGalleryButton.addTarget(self, action: #selector(cameraGalleryButtonClicked), for: .touchUpInside)
        webSearchButton.addTarget(self, action: #selector(webSearchButtonClicked), for: .touchUpInside)
    }
    
    @objc private func completeButtonClicked() {
        print(#function)
        actionDelegate?.completePillRegister()
    }
    
    @objc private func defaultImageButtonClicked() {
        print(#function)
        actionDelegate?.defaultImageButtonClicked()
    }
    
    @objc private func defaultButtonClicked() {
        print(#function)
        actionDelegate?.defaultButtonAction()
    }
    
    @objc private func cameraGalleryButtonClicked() {
        print(#function)
        actionDelegate?.cameraGalleryButtonAction()
    }
    
    @objc private func webSearchButtonClicked() {
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
    
    func itemHidden(_ value : Bool = true) {
        userInputTextfield.isEnabled = value
        addImageTitleLabel.isHidden = value
        defaultImageButton.isHidden = value
        buttonStackView.isHidden = value
        pillImageView.isHidden = value
        completeButton.isHidden = value
    }
    
    deinit {
        print(#function, " - ✅ RegisterPillView in-Side")
    }
    
}
