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
            
            cell.actionDelegate = self
            cell.viewModel.inputCurrentDateAlarmPill.value = Array(pillList)
            cell.viewModel.inputCurrentGroupID.value = itemIdentifier.alarmName
            
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
    
    @objc private func dismissAlertController(){
        self.dismiss(animated: true, completion: nil)
    }
    
    deinit {
        print(#function, " - PillNotificationContentViewController ✅")
    }
}

//MARK: - CollectionView Deleagte
extension PillNotificationContentViewController : UICollectionViewDelegate {
    
}

//MARK: - Delegate Action
extension PillNotificationContentViewController : PillNotificationAction {
    func containPillButton(_ groupID : String?, _ data : [Pill]?) {
        
        guard let groupID = groupID else { return }
        guard let data = data else { return }
        
        let vc = PopUpPillAlarmGroupViewController()
        vc.viewModel.inputCurrentDateAlarmPill.value = data
        
        let alert = UIAlertController(title: "🌟" + groupID, message: nil, preferredStyle: .actionSheet)
        alert.view.tintColor = DesignSystem.colorSet.lightBlack

        let constraintHeight = NSLayoutConstraint(
            item: alert.view!, attribute: NSLayoutConstraint.Attribute.height, relatedBy: NSLayoutConstraint.Relation.equal, toItem: nil, attribute:
                NSLayoutConstraint.Attribute.notAnAttribute, multiplier: 1, constant: 200)
        alert.view.addConstraint(constraintHeight)
        alert.setValue(vc, forKey: "contentViewController")
        
        present(alert, animated: true) { [weak self] in
            guard let self = self else { return }
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.dismissAlertController))
            alert.view.superview?.subviews[0].addGestureRecognizer(tapGesture)
        }
    }
}
