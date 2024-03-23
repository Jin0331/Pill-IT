//
//  PillAlarmReviseItemView.swift
//  Pill-IT
//
//  Created by JinwooLee on 3/22/24.
//

import UIKit
import SnapKit
import Then
import NVActivityIndicatorView

final class PillAlarmReviseItemView : BaseView {
    
    weak var actionDelegate : PillAlarmReigsterAction?
    
    let scrollView = UIScrollView().then {
        $0.backgroundColor = DesignSystem.colorSet.white
        $0.isScrollEnabled = true
        $0.showsVerticalScrollIndicator = true
        $0.bounces = false
    }
    
    let contentsView = UIView().then {
        $0.backgroundColor = DesignSystem.colorSet.white
    }
    
    let collectionViewtitle = UILabel().then {
        $0.text = "선택한 복용약 수정"
        $0.textColor = DesignSystem.colorSet.gray
        $0.font = .systemFont(ofSize: 15, weight: .heavy)
    }
    
    lazy var mainCollectionView : UICollectionView = {
        let view = UICollectionView(frame: .zero, collectionViewLayout: createLayout())
        view.backgroundColor = DesignSystem.colorSet.white

        return view
    }()
    
    let periodSelectButtontitle = UILabel().then {
        $0.text = "주기 수정"
        $0.textColor = DesignSystem.colorSet.gray
        $0.font = .systemFont(ofSize: 15, weight: .heavy)
    }
    
    let periodSelectButton = UIButton().then {
        $0.setTitle("주기 설정하기", for: .normal)
        $0.setTitleColor(DesignSystem.colorSet.lightBlack, for: .normal)
        $0.titleLabel?.font = .systemFont(ofSize: 17, weight: .heavy)
        $0.layer.borderWidth = DesignSystem.viewLayout.borderWidth
        $0.layer.borderColor = DesignSystem.colorSet.lightBlack.cgColor
        $0.layer.cornerRadius = DesignSystem.viewLayout.cornerRadius
    }
    
    let startDateButtontitle = UILabel().then {
        $0.text = "시작일 수정"
        $0.textColor = DesignSystem.colorSet.gray
        $0.font = .systemFont(ofSize: 15, weight: .heavy)
    }
    
    let startDateButton = UIButton().then {
        $0.setTitle("시작일 설정하기", for: .normal)
        $0.setTitleColor(DesignSystem.colorSet.lightBlack, for: .normal)
        $0.setImage(DesignSystem.sfSymbol.startDate, for: .normal)
        $0.titleLabel?.font = .systemFont(ofSize: 17, weight: .heavy)
        $0.tintColor = DesignSystem.colorSet.lightBlack
        $0.layer.borderWidth = DesignSystem.viewLayout.borderWidth
        $0.layer.borderColor = DesignSystem.colorSet.lightBlack.cgColor
        $0.layer.cornerRadius = DesignSystem.viewLayout.cornerRadius
    }
    
    let completeButton = UIButton().then {
        $0.setTitle("수정 완료", for: .normal)
        $0.setTitleColor(DesignSystem.colorSet.white, for: .normal)
        $0.titleLabel?.font = .systemFont(ofSize: 20, weight: .heavy)
        $0.backgroundColor = DesignSystem.colorSet.lightBlack
        $0.layer.cornerRadius = DesignSystem.viewLayout.cornerRadius
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
        
        [scrollView].forEach {
            addSubview($0)
        }
        
        scrollView.addSubview(contentsView)
        
        [collectionViewtitle, mainCollectionView, periodSelectButtontitle, periodSelectButton, startDateButtontitle, startDateButton, completeButton].forEach { contentsView.addSubview($0)}
    }
    
    override func configureLayout() {
        
        scrollView.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide).inset(10)
            $0.horizontalEdges.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
        
        contentsView.snp.makeConstraints {
            $0.width.equalToSuperview()
            $0.top.bottom.equalToSuperview()
        }
        
        collectionViewtitle.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(25)
            make.horizontalEdges.equalToSuperview().inset(10)
        }

        periodSelectButtontitle.snp.makeConstraints { make in
            make.top.equalTo(mainCollectionView.snp.bottom).offset(15)
            make.width.equalTo(collectionViewtitle)
            make.leading.equalTo(mainCollectionView)
        }
        
        periodSelectButton.snp.makeConstraints { make in
            make.top.equalTo(periodSelectButtontitle.snp.bottom).offset(10)
            make.horizontalEdges.equalTo(mainCollectionView)
            make.height.equalTo(70)
        }
        
        startDateButtontitle.snp.makeConstraints { make in
            make.top.equalTo(periodSelectButton.snp.bottom).offset(15)
            make.width.equalTo(collectionViewtitle)
            make.leading.equalTo(mainCollectionView)
        }
        
        startDateButton.snp.makeConstraints { make in
            make.top.equalTo(startDateButtontitle.snp.bottom).offset(10)
            make.horizontalEdges.equalTo(mainCollectionView)
            make.height.equalTo(periodSelectButton)
        }
        
        completeButton.snp.makeConstraints { make in
            make.top.equalTo(startDateButton.snp.bottom).offset(20)
            make.horizontalEdges.equalTo(startDateButton)
            make.height.equalTo(periodSelectButton)
            make.bottom.equalToSuperview().inset(20)
        }
    }
    
    override func configureView() {
        super.configureView()
        
        periodSelectButton.addTarget(self, action: #selector(periodSelectButtonClicked), for: .touchUpInside)
        startDateButton.addTarget(self, action: #selector(startDateButtonClicked), for: .touchUpInside)
        completeButton.addTarget(self, action: #selector(completeButtonClicked), for: .touchUpInside)
    }
    
    @objc private func periodSelectButtonClicked() {
        print(#function)
        actionDelegate?.periodSelectPresent()
    }
    
    @objc private func startDateButtonClicked() {
        print(#function)
        actionDelegate?.startDateSelectPresent()
    }
    
    @objc private func completeButtonClicked() {
        print(#function)
        actionDelegate?.completeButtonAction()
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
        let oneItemSize = 60
        let size = itemCount < 4 ? oneItemSize * itemCount : oneItemSize * 3
    
        mainCollectionView.snp.updateConstraints { make in
            make.top.equalTo(collectionViewtitle.snp.bottom).offset(10)
            make.horizontalEdges.equalToSuperview().inset(10)
            make.height.equalTo(size)
        }
    }

    deinit {
        print(#function, " - ✅ PillAlaramView in-Side")
    }
}
