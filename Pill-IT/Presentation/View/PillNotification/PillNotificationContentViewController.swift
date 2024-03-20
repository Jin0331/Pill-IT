//
//  PillNotificationContentViewController.swift
//  Pill-IT
//
//  Created by JinwooLee on 3/20/24.
//

import UIKit

final class PillNotificationContentViewController: BaseViewController {
    
    let mainView = PillNotificationContentView()
    let viewModel = PillNotificationViewModel()
    private var dataSource : UICollectionViewDiffableDataSource<PillNotificationContent, PillAlarmDate>!
    
    init(currentDate : Date) {
        super.init(nibName: nil, bundle: nil)
        viewModel.inputCurrentDate.value = currentDate
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = mainView
        mainView.mainCollectionView.delegate = self
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureDataSource()
        bindData()
    }
    
    private func bindData() {
        viewModel.outputCurrentDateAlarm.bind { [weak self] value in
            guard let self = self else { return }
            guard let value = value else { return }
            
            updateSnapshot(value)
        }
    }
    
    private func configureDataSource() {
        
        let cellRegistration = mainView.pillNotificationContentCellRegistration()
        dataSource = UICollectionViewDiffableDataSource(collectionView: mainView.mainCollectionView, cellProvider: { [weak self] collectionView, indexPath, itemIdentifier in
            guard let self = self else { return UICollectionViewCell()}
            guard let pillList = itemIdentifier.alarmGroup.first?.pillList else { return UICollectionViewCell()}
            
            let cell = collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: itemIdentifier)
            
            print(itemIdentifier.alarmGroup.first?.alarmName)
            
            cell.viewModel.inputCurrentDateAlarmPill.value = Array(pillList)
            
            return cell
        })
    }
    
    private func updateSnapshot(_ data : [PillAlarmDate]) {
        var snapshot = NSDiffableDataSourceSnapshot<PillNotificationContent, PillAlarmDate>()
        snapshot.appendSections(PillNotificationContent.allCases)
        snapshot.appendItems(data, toSection: .main)
        
        dataSource.apply(snapshot) // reloadData
        print("PillNotificationContentViewController UpdateSnapShot ❗️❗️❗️❗️❗️❗️❗️")
    }
    
    
    deinit {
        print(#function, " - PillNotificationContentViewController ✅")
    }
}

extension PillNotificationContentViewController : UICollectionViewDelegate {
    
}
