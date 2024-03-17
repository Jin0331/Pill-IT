//
//  PeriodSelectViewController.swift
//  Pill-IT
//
//  Created by JinwooLee on 3/17/24.
//

import UIKit
import SnapKit
import Then

final class PeriodSelectViewController: BaseViewController {

    let mainView = PeriodSelectView()
    weak var viewModel : PillAlaramRegisterViewModel?
    private var dataSource : UICollectionViewDiffableDataSource<PeriodViewSection, PeriodCase>!
    var sendPeriodSelectButtonTitle : ((String) -> Void)?
    
    override func loadView() {
        view = mainView
        mainView.mainCollectionView.delegate = self
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
                
        configureDataSource()
        updateSnapshot(PeriodCase.allCases)

    }
    
    override func configureNavigation() {
        super.configureNavigation()
        
        navigationItem.title = "🗓️ 주기 선택"
        navigationItem.largeTitleDisplayMode = .never
        navigationItem.rightBarButtonItem = nil
    }
    
    private func configureDataSource() {
        
        let cellRegistration = mainView.periodSelectCellRegistration()
        dataSource = UICollectionViewDiffableDataSource(collectionView: mainView.mainCollectionView, cellProvider: { collectionView, indexPath, itemIdentifier in
            let cell = collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: itemIdentifier)
            
            return cell
        })
    }
    
    private func updateSnapshot(_ data : [PeriodCase]) {
        var snapshot = NSDiffableDataSourceSnapshot<PeriodViewSection, PeriodCase>()
        snapshot.appendSections(PeriodViewSection.allCases)
        snapshot.appendItems(data, toSection: .main)
        
        dataSource.apply(snapshot) // reloadData
        
        print(#function, "PeriodSelectViewController UpdateSnapShot ❗️❗️❗️❗️❗️❗️❗️")
    }
    
    deinit {
        print(#function, " - ✅ PeriodSelectController")
    }
}

extension PeriodSelectViewController : UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        guard let viewModel = viewModel else { return }
        guard let selectItem = dataSource.itemIdentifier(for: indexPath) else { return }
        
        switch selectItem {
        case .always:
            viewModel.inputPeriodType.value = selectItem
            viewModel.outputPeriodType.bind { [weak self] value in
                guard let self = self else { return }
                sendPeriodSelectButtonTitle?(value)
            }
            
            dismiss(animated: true)
            
        case .specificDay:
            print(selectItem.rawValue)
            
            let vc = PeriodSelectDayOfTheWeekViewController()
            vc.viewModel = viewModel // ViewModel 공유
            
            vc.sendPeriodSelectedItem = { [weak self]  in // PeriodCase list
                guard let self = self else { return }
                viewModel.inputPeriodType.value = selectItem
                viewModel.outputPeriodType.bind { [weak self] value in
                    guard let self = self else { return }
                    sendPeriodSelectButtonTitle?(value)
                }

                dismiss(animated: true)
            }
            navigationController?.pushViewController(vc, animated: true)
            
        case .period:
            print(selectItem.rawValue)
        }
    }
}
