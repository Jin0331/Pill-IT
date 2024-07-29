//
//  PeriodSelectDayOfTheWeekViewController.swift
//  Pill-IT
//
//  Created by JinwooLee on 3/17/24.
//

import UIKit
import SnapKit
import Then

final class PeriodSelectDayOfTheWeekViewController: BaseViewController {

    var viewModel : PillAlaramRegisterViewModel?
    var sendPeriodSelectedItem : (() -> Void)? //  PeriodSelectViewController 으로 보냄. popup 할때
    
    lazy private var mainCollectionView = UICollectionView(frame: .zero, collectionViewLayout: createLayout()).then {
        $0.backgroundColor = DesignSystem.colorSet.white
        $0.allowsMultipleSelection = true
        $0.delegate = self
    }
    
    let customButton = UIButton(frame: CGRect(x: 0, y: 0, width: 40, height: 40)).then {
        $0.setTitle("완료", for: .normal)
        $0.titleLabel?.font = .systemFont(ofSize: 15, weight: .heavy)
        $0.setTitleColor(DesignSystem.colorSet.lightBlack, for: .normal)
    }
    
    private var dataSource : UICollectionViewDiffableDataSource<PeriodViewSection, PeriodSpecificDay>!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureDataSource()
        updateSnapshot(PeriodSpecificDay.allCases)

    }

    override func configureNavigation() {
        super.configureNavigation()
        
        navigationItem.title = "특정 요일"
        
        customButton.addTarget(self, action: #selector(rightBarButtonClicked), for: .touchUpInside)
        customButton.tintColor = DesignSystem.colorSet.lightBlack
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: customButton)
        if #available(iOS 16.0, *) {
            navigationItem.rightBarButtonItem?.isHidden = true
        } else {
            navigationItem.rightBarButtonItem?.customView?.isHidden = true
        }
    }
    
    
    override func configureHierarchy() {
        view.addSubview(mainCollectionView)
    }
    
    override func configureLayout() {
        mainCollectionView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    @objc private func rightBarButtonClicked() {
        guard let viewModel = viewModel else { return }
        guard let selectedIndexPaths = mainCollectionView.indexPathsForSelectedItems else { return }
        
        let selectedIndexPathsSorted = selectedIndexPaths.sorted()
        let selectedPill = selectedIndexPathsSorted.map{ return dataSource.itemIdentifier(for: $0)!}
        viewModel.inputDayOfWeekInterval.value = selectedPill
        sendPeriodSelectedItem?()

        navigationController?.popViewController(animated: true)
    }
    
    deinit {
        print("✅ PeriodSelectDayOfTheWeekViewController")
    }
}

//MARK: - CollectionView Delegate
extension PeriodSelectDayOfTheWeekViewController : UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        hiddenRightBarButton(collectionView)
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        hiddenRightBarButton(collectionView)
    }
    
    // version 대응
    // IOS 15에서는 navigationItem.leftBarButtonItem?.isHidden 없음
    private func hiddenRightBarButton(_ collectionView : UICollectionView) {
        if let isAllHideen = collectionView.indexPathsForSelectedItems, isAllHideen.isEmpty {
            if #available(iOS 16.0, *) {
                navigationItem.rightBarButtonItem?.isHidden = true
            } else {
                navigationItem.rightBarButtonItem?.customView?.isHidden = true
            }
        } else {
            if #available(iOS 16.0, *) {
                navigationItem.rightBarButtonItem?.isHidden = false
            } else {
                // Fallback on earlier versions
                navigationItem.rightBarButtonItem?.customView?.isHidden = false
            }
        }
    }
}

//MARK: - CollectionView UI
extension PeriodSelectDayOfTheWeekViewController {
    private func createLayout() -> UICollectionViewLayout {
        var configuration = UICollectionLayoutListConfiguration(appearance: .grouped)
        configuration.backgroundColor = DesignSystem.colorSet.white
        configuration.showsSeparators = true
        
        let layout = UICollectionViewCompositionalLayout.list(using: configuration)
        
        return layout
    }
    
    private func periodSelectDayOfTheWeekCellRegistration() -> UICollectionView.CellRegistration<UICollectionViewListCell, PeriodSpecificDay> {
        
        let cellRegistration = UICollectionView.CellRegistration<UICollectionViewListCell, PeriodSpecificDay> { cell, indexPath, itemIdentifier in
            
            var content = UIListContentConfiguration.subtitleCell()
            content.text = itemIdentifier.toStringForCollectionView
            
            cell.contentConfiguration = content
        }
        
        return cellRegistration
    }
    
    private func configureDataSource() {
        
        let cellRegistration = periodSelectDayOfTheWeekCellRegistration()
        dataSource = UICollectionViewDiffableDataSource(collectionView: mainCollectionView, cellProvider: { collectionView, indexPath, itemIdentifier in
            let cell = collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: itemIdentifier)
            
            return cell
        })
    }
    
    private func updateSnapshot(_ data : [PeriodSpecificDay]) {
        var snapshot = NSDiffableDataSourceSnapshot<PeriodViewSection, PeriodSpecificDay>()
        snapshot.appendSections(PeriodViewSection.allCases)
        snapshot.appendItems(data, toSection: .main)
        
        dataSource.apply(snapshot) // reloadData
    }
}
