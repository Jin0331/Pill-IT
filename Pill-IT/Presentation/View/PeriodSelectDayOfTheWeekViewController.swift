//
//  PeriodSelectDayOfTheWeekViewController.swift
//  Pill-IT
//
//  Created by JinwooLee on 3/17/24.
//

import UIKit
import SnapKit
import Then

final class PeriodSelectDayOfTheWeekViewController: BaseViewController, UICollectionViewDelegate {

    var viewModel : PillAlaramRegisterViewModel?
    var sendPeriodSelectedItem : (() -> Void)? //  PeriodSelectViewController 으로 보냄. popup 할때
    
    lazy private var mainCollectionView = UICollectionView(frame: .zero, collectionViewLayout: createLayout()).then {
        $0.backgroundColor = DesignSystem.colorSet.white
        $0.allowsMultipleSelection = true
        $0.delegate = self
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
        
        let rightCompleteBarButton = UIBarButtonItem(title: "완료", style: .done, target: self, action: #selector(rightBarButtonClicked))
        rightCompleteBarButton.tintColor = DesignSystem.colorSet.lightBlack
        navigationItem.rightBarButtonItem = rightCompleteBarButton
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
        
        print(#function, "PeriodSelectDayOfTheWeekViewController UpdateSnapShot ❗️❗️❗️❗️❗️❗️❗️")
    }
}
