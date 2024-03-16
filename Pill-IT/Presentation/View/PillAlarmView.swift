//
//  PillAlarmView.swift
//  Pill-IT
//
//  Created by JinwooLee on 3/16/24.
//

import UIKit
import SnapKit
import Then

final class PillAlarmView : BaseView {
    
    let exitButton = UIButton().then {
        $0.setImage(DesignSystem.iconImage.clear, for: .normal)
        $0.tintColor = DesignSystem.colorSet.black
    }
    
    let titleLabel = UILabel().then {
        $0.text = "🗓️ 복용 알림 등록하기"
        $0.textColor = DesignSystem.colorSet.black
        $0.font = .systemFont(ofSize: 28, weight: .heavy)
        $0.layer.shadowOffset = CGSize(width: 10, height: 5)
        $0.layer.shadowOpacity = 0.4
        $0.layer.shadowRadius = 10
        $0.layer.masksToBounds = false
    }
    
    let scrollView = UIScrollView().then {
        $0.backgroundColor = DesignSystem.colorSet.white
        $0.isScrollEnabled = true
        $0.showsVerticalScrollIndicator = true
    }
    
    let contentsView = UIView().then {
        $0.backgroundColor = DesignSystem.colorSet.white
    }
    
    let collectionViewtitle = UILabel().then {
        $0.text = "선택한 복용약 목록"
        $0.textColor = DesignSystem.colorSet.gray
        $0.font = .systemFont(ofSize: 15, weight: .heavy)
    }
    
    lazy var mainCollectionView : UICollectionView = {
        let view = UICollectionView(frame: .zero, collectionViewLayout: createLayout())
//        view.backgroundColor = DesignSystem.colorSet.white
        view.backgroundColor = .red

        return view
    }()
    
    let userInputTextfieldtitle = UILabel().then {
        $0.text = "알림 이름 설정"
        $0.textColor = DesignSystem.colorSet.gray
        $0.font = .systemFont(ofSize: 15, weight: .heavy)
    }
    
    let userInputTextfield = UITextField().then {
        $0.attributedPlaceholder = NSAttributedString(string: "복용 알림의 이름을 입력해주세요", attributes: [NSAttributedString.Key.foregroundColor : DesignSystem.colorSet.gray])
        $0.addLeftPadding()
        $0.clearButtonMode = .whileEditing
        $0.font = .systemFont(ofSize: 23, weight: .heavy)
        $0.textColor = DesignSystem.colorSet.black
        $0.layer.borderWidth = DesignSystem.viewLayout.borderWidth
        $0.layer.borderColor = DesignSystem.colorSet.lightBlack.cgColor
        $0.layer.cornerRadius = DesignSystem.viewLayout.cornerRadius
    }
    
    let periodSelectButtontitle = UILabel().then {
        $0.text = "주기 설정"
        $0.textColor = DesignSystem.colorSet.gray
        $0.font = .systemFont(ofSize: 15, weight: .heavy)
    }
    
    let periodSelectButton = UIButton().then {
        $0.setTitle("주기 설정하기", for: .normal)
        $0.setTitleColor(DesignSystem.colorSet.gray, for: .normal)
        $0.titleLabel?.font = .systemFont(ofSize: 23, weight: .heavy)
        $0.layer.borderWidth = DesignSystem.viewLayout.borderWidth
        $0.layer.borderColor = DesignSystem.colorSet.lightBlack.cgColor
        $0.layer.cornerRadius = DesignSystem.viewLayout.cornerRadius
    }
    
    let startDateButtontitle = UILabel().then {
        $0.text = "시작일 설정"
        $0.textColor = DesignSystem.colorSet.gray
        $0.font = .systemFont(ofSize: 15, weight: .heavy)
    }
    
    let startDateButton = UIButton().then {
        $0.setTitle("시작일 설정하기", for: .normal)
        $0.setTitleColor(DesignSystem.colorSet.gray, for: .normal)
        $0.titleLabel?.font = .systemFont(ofSize: 23, weight: .heavy)
        $0.layer.borderWidth = DesignSystem.viewLayout.borderWidth
        $0.layer.borderColor = DesignSystem.colorSet.lightBlack.cgColor
        $0.layer.cornerRadius = DesignSystem.viewLayout.cornerRadius
    }
    
    let completeButton = UIButton().then {
        $0.setTitle("복용 알람 등록 🥰", for: .normal)
        $0.setTitleColor(DesignSystem.colorSet.white, for: .normal)
        $0.titleLabel?.font = .systemFont(ofSize: 23, weight: .heavy)
        $0.backgroundColor = DesignSystem.colorSet.lightBlack
        $0.layer.cornerRadius = DesignSystem.viewLayout.cornerRadius
    }
    
    override func configureHierarchy() {
        
        [exitButton, titleLabel, scrollView].forEach {
            addSubview($0)
        }
        
        scrollView.addSubview(contentsView)
        
        [collectionViewtitle, mainCollectionView, userInputTextfieldtitle, userInputTextfield, periodSelectButtontitle, periodSelectButton, startDateButtontitle, startDateButton, completeButton].forEach { contentsView.addSubview($0)}
    }
    
    override func configureLayout() {
        exitButton.snp.makeConstraints { make in
            make.top.trailing.equalToSuperview().inset(20)
            make.size.equalTo(30)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(exitButton.snp.bottom).offset(10)
            make.horizontalEdges.equalToSuperview().inset(20)
            make.height.equalTo(50)
        }
        
        scrollView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(10)
            $0.horizontalEdges.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
        
        contentsView.snp.makeConstraints {
            $0.width.equalToSuperview()
            $0.top.bottom.equalToSuperview()
        }
        
        collectionViewtitle.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(15)
            make.width.equalTo(120)
            make.leading.equalTo(titleLabel)
        }
        
        userInputTextfieldtitle.snp.makeConstraints { make in
            make.top.equalTo(mainCollectionView.snp.bottom).offset(10)
            make.width.equalTo(collectionViewtitle)
            make.leading.equalTo(mainCollectionView)
        }
        
        userInputTextfield.snp.makeConstraints { make in
            make.top.equalTo(userInputTextfieldtitle.snp.bottom).offset(10)
            make.horizontalEdges.equalTo(mainCollectionView)
            make.height.equalTo(70)
        }
        
        periodSelectButtontitle.snp.makeConstraints { make in
            make.top.equalTo(userInputTextfield.snp.bottom).offset(15)
            make.width.equalTo(collectionViewtitle)
            make.leading.equalTo(mainCollectionView)
        }
        
        periodSelectButton.snp.makeConstraints { make in
            make.top.equalTo(periodSelectButtontitle.snp.bottom).offset(10)
            make.horizontalEdges.equalTo(mainCollectionView)
            make.height.equalTo(userInputTextfield)
        }
        
        startDateButtontitle.snp.makeConstraints { make in
            make.top.equalTo(periodSelectButton.snp.bottom).offset(15)
            make.width.equalTo(userInputTextfield)
            make.leading.equalTo(mainCollectionView)
        }
        
        startDateButton.snp.makeConstraints { make in
            make.top.equalTo(startDateButtontitle.snp.bottom).offset(10)
            make.horizontalEdges.equalTo(mainCollectionView)
            make.height.equalTo(userInputTextfield)
        }
        
        completeButton.snp.makeConstraints { make in
            make.top.equalTo(startDateButton.snp.bottom).offset(20)
            make.horizontalEdges.equalTo(startDateButton)
            make.height.equalTo(userInputTextfield)
            make.bottom.equalToSuperview()
        }
    }
    
    private func createLayout() -> UICollectionViewLayout {
        
        // Cell
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        // Group
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(50))
        
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])

        // Section
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = 3
        
        let layout = UICollectionViewCompositionalLayout(section: section)
        
        return layout
    }
    
    func pillAlarmCellRegistration() -> UICollectionView.CellRegistration<PillAlarmCollectionViewCell, Pill>  {
        
        return UICollectionView.CellRegistration<PillAlarmCollectionViewCell, Pill> { cell, indexPath, itemIdentifier in
            cell.updateUI(itemIdentifier)
        }
    }
    
    func collectionViewchangeLayout(itemCount: Int) {
        
        print("🥲 CollectionView Resize")

        let defaultSize = itemCount < 5 ? 50 * itemCount : 50 * 3
    
        mainCollectionView.snp.updateConstraints { make in
            make.top.equalTo(collectionViewtitle.snp.bottom).offset(10)
            make.horizontalEdges.equalTo(titleLabel)
            make.height.equalTo(defaultSize)
        }
    }
    
    
    
    deinit {
        print(#function, " - ✅ PillAlaramView in-Side")
    }
}
