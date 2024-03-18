//
//  PillAlarmSpecificViewController.swift
//  Pill-IT
//
//  Created by JinwooLee on 3/18/24.
//

import UIKit
import SwipeCellKit

//TODO: -
// 삭제할 떄 최소 1개 이상 있도록 예외
// 동일한 시간 판단해서 동일한 시간 있으면 추가 안 되도록, 수정도 마찬가지임

final class PillAlarmSpecificViewController: BaseViewController {

    let mainView = PillAlarmSpecificView()
    weak var viewModel : PillAlaramRegisterViewModel?
    private var dataSource : UICollectionViewDiffableDataSource<PillAlarmSpecificViewSection, Date>!
    
    override func loadView() {
        view = mainView
        mainView.actionDelegate = self
        mainView.mainCollectionView.delegate = self
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureDataSource()
        bindData()

    }
    
    private func bindData() {
        guard let viewModel = viewModel else { return }
        viewModel.inputAlarmSpecificTimeList.value = [(7,0), (12,0), (19,0), (22,0)] // input
        
        print(viewModel.outputAlarmSpecificTimeList.value, "이야호₩")
        
        viewModel.outputVisibleSpecificTimeList.bind { [weak self] value in
            guard let self = self else { return }

            updateSnapshot(value)
        }
    }
    
    override func configureNavigation() {
        super.configureNavigation()
        
        navigationItem.title = "🗓️ 복용 알림 등록 완료하기"
        navigationController?.navigationBar.prefersLargeTitles = false
        navigationItem.rightBarButtonItem = nil
    }

    private func configureDataSource() {
        
        let cellRegistration = mainView.pillAlarmSpecificCellRegistration()
        dataSource = UICollectionViewDiffableDataSource(collectionView: mainView.mainCollectionView, cellProvider: { [weak self] collectionView, indexPath, itemIdentifier in
            let cell = collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: itemIdentifier)
            cell.delegate = self
            
            return cell
        })
    }
    
    private func updateSnapshot(_ data : [Date]) {
        var snapshot = NSDiffableDataSourceSnapshot<PillAlarmSpecificViewSection, Date>()
        snapshot.appendSections(PillAlarmSpecificViewSection.allCases)
        snapshot.appendItems(data, toSection: .main)
        
        dataSource.apply(snapshot) // reloadData
        
        print(#function, "PillManageMent UpdateSnapShot ❗️❗️❗️❗️❗️❗️❗️")
    }
    
    
    deinit {
        print(#function, " - ✅ PillAlaamSpecificViewController")
    }
}

//MARK: - CollectionView Delegate
extension PillAlarmSpecificViewController : UICollectionViewDelegate {
    
}

extension PillAlarmSpecificViewController : SwipeCollectionViewCellDelegate {
    func collectionView(_ collectionView: UICollectionView, editActionsForItemAt indexPath: IndexPath, for orientation: SwipeCellKit.SwipeActionsOrientation) -> [SwipeCellKit.SwipeAction]? {
        
        return nil
    }
    
    
}

//MARK: - Delegate Action
extension PillAlarmSpecificViewController : PillSpecificAction {
    func addButtonAction() {
        print(#function)
    }
    
    func completeButtonAction() {
        print(#function)
    }
    
    
}
