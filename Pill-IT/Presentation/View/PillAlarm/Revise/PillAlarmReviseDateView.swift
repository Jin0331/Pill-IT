//
//  PillAlarmReviseDateView.swift
//  Pill-IT
//
//  Created by JinwooLee on 3/23/24.
//

import UIKit
import SnapKit
import Then
import NVActivityIndicatorView

final class PillAlarmReviseDateView: BaseView {

    weak var actionDelegate : PillSpecificAction?
    
    let headerLabel = UILabel().then {
        $0.text = "세부 알림 시간을 수정해주세요 🥸"
        $0.textColor = DesignSystem.colorSet.black
        $0.font = .systemFont(ofSize: 22, weight: .heavy)
        $0.textAlignment = .center
    }
    
    lazy var mainCollectionView : UICollectionView = {
        let view = UICollectionView(frame: .zero, collectionViewLayout: createLayout())
        view.backgroundColor = DesignSystem.colorSet.white

        return view
    }()
    
    let addButton = UIButton().then {
        $0.setImage(DesignSystem.sfSymbol.plus, for: .normal)
        $0.tintColor = DesignSystem.colorSet.white
        $0.backgroundColor = DesignSystem.colorSet.lightBlack
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
        
        [headerLabel, addButton, mainCollectionView, completeButton].forEach {
            addSubview($0)
        }
    }
    
    override func configureLayout() {
        super.configureLayout()
        
        headerLabel.snp.makeConstraints { make in
            make.top.horizontalEdges.equalTo(safeAreaLayoutGuide).inset(20)
            make.height.equalTo(50)
        }
        
        addButton.snp.makeConstraints { make in
            make.top.equalTo(headerLabel.snp.bottom).offset(10)
            make.trailing.equalTo(mainCollectionView)
            make.size.equalTo(50)
        }
        
        mainCollectionView.snp.makeConstraints { make in
            make.top.equalTo(addButton.snp.bottom).offset(10)
            make.horizontalEdges.equalToSuperview().inset(20)
        }
        
        completeButton.snp.makeConstraints { make in
            make.height.equalTo(70)
            make.top.equalTo(mainCollectionView.snp.bottom).offset(15)
            make.horizontalEdges.bottom.equalTo(safeAreaLayoutGuide)
        }
    }
    
    override func configureView() {
        super.configureView()
        
        addButton.addTarget(self, action: #selector(addButtonClicked), for: .touchUpInside)
        completeButton.addTarget(self, action: #selector(completeButtonClicked), for: .touchUpInside)
    }
    
    @objc private func addButtonClicked() {
        print(#function)
        actionDelegate?.addButtonAction()
    }
    
    @objc private func completeButtonClicked() {
        print(#function)
        actionDelegate?.completeButtonAction()
    }

    func pillAlarmSpecificCellRegistration() -> UICollectionView.CellRegistration<PillAlarmSpecificCollectionViewCell, Date>  {
        
        return UICollectionView.CellRegistration<PillAlarmSpecificCollectionViewCell, Date> { cell, indexPath, itemIdentifier in
            cell.updateUI(itemIdentifier)
        }
    }

    private func createLayout() -> UICollectionViewLayout {
        
        // Cell
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        // Group
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(80))
        
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])

        // Section
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = 10
        
        let layout = UICollectionViewCompositionalLayout(section: section)
        
        return layout
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

}

