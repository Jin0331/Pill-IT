//
//  RegisterPillWebSearchViewController.swift
//  Pill-IT
//
//  Created by JinwooLee on 3/12/24.
//

import UIKit
import SnapKit
import Then
import Kingfisher
import collection_view_layouts

final class RegisterPillWebSearchViewController: BaseViewController {
        
    weak var viewModel : RegisterPillViewModel?
    var dataSource : UICollectionViewDiffableDataSource<Section, URL>!
    var sendData : ((URL) -> Void)?
    
    // UI
    private lazy var seaerchCollectionView : UICollectionView = {
        let view = UICollectionView(frame: .zero, collectionViewLayout: createLayout())
        view.delegate = self
        
       return view
    }()
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureDataSource()
        bindData()
    }
    
    private func bindData() {
        guard let viewModel = viewModel else { return }
        
        viewModel.outputItemImageWebLink.bind { [weak self] value in
            guard let self = self else { return }
            guard let value = value else { return }
            
            self.updateSnapshot()
        }
        
    }
    
    override func configureHierarchy() {
        view.addSubview(seaerchCollectionView)
    }
    
    override func configureLayout() {
        seaerchCollectionView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    // Like 인스타그램
    // 출처: https://kangheeseon.tistory.com/16
    private func createLayout() -> UICollectionViewLayout {
        let fullPhotoItem = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalWidth(2/3)))
            fullPhotoItem.contentInsets = NSDirectionalEdgeInsets(top: 2, leading: 2, bottom: 2, trailing: 2)
        
        let mainItem = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(2/3), heightDimension: .fractionalHeight(1.0)))
        mainItem.contentInsets = NSDirectionalEdgeInsets(top: 2, leading: 2, bottom: 2, trailing: 2)
        let pairItem = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(0.5)))
        pairItem.contentInsets = NSDirectionalEdgeInsets(top: 2, leading: 2, bottom: 2, trailing: 2)

        let trailingGroup = NSCollectionLayoutGroup.vertical(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1/3), heightDimension: .fractionalHeight(1.0)), subitem: pairItem, count: 2)
        let mainWithTrailingGroup = NSCollectionLayoutGroup.horizontal(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalWidth(4/9)), subitems: [mainItem, trailingGroup])

        let tripleItem = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1/3), heightDimension: .fractionalHeight(1.0)))
        tripleItem.contentInsets = NSDirectionalEdgeInsets(top: 2, leading: 2, bottom: 2, trailing: 2)
        let tripleGroup = NSCollectionLayoutGroup.horizontal(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalWidth(2/9)), subitem: tripleItem, count: 3)
        

        let mainWithReversedGroup = NSCollectionLayoutGroup.horizontal(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalWidth(4/9)), subitems: [trailingGroup, mainItem])
        let nestedGroup = NSCollectionLayoutGroup.vertical(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalWidth(16/9)), subitems: [fullPhotoItem, mainWithTrailingGroup, tripleGroup, mainWithReversedGroup])
        let section = NSCollectionLayoutSection(group: nestedGroup)
        let layout = UICollectionViewCompositionalLayout(section: section)
        
        
        return layout
    }
    
    private func configureDataSource() {
        
        let cellRegistration = UICollectionView.CellRegistration<RegisterPillWebSearchCollectionViewCell, URL> { cell, indexPath, itemIdentifier in
            
            DispatchQueue.global().async(qos : .userInteractive) {
                let url = itemIdentifier
                let data = try? Data(contentsOf: url)
                
                DispatchQueue.main.async {
                    cell.webImage.image = UIImage(data: data!)
                }
            }
        }
        
        dataSource = UICollectionViewDiffableDataSource(collectionView: seaerchCollectionView, cellProvider: { collectionView, indexPath, itemIdentifier in
            let cell = collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: itemIdentifier)
            
            return cell
        })
    }

    private func updateSnapshot() {
        guard let viewModel = viewModel else { return }
        guard let outputItemImageWebLink = viewModel.outputItemImageWebLink.value else { print("안찍히냐");return }
        var snapshot = NSDiffableDataSourceSnapshot<Section, URL>()
        snapshot.appendSections(Section.allCases)
        snapshot.appendItems(outputItemImageWebLink, toSection: .main)
        dataSource.apply(snapshot) // reloadData
        
//        dataSource.applySnapshotUsingReloadData(<#T##snapshot: NSDiffableDataSourceSnapshot<Section, URL>##NSDiffableDataSourceSnapshot<Section, URL>#>)
    }
    
    deinit {
        print(#function, "RegisterPillWebSearchViewController")
    }
    
    
}


extension RegisterPillWebSearchViewController : UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        print(#function, " - image select")
        
        guard let viewModel = viewModel else { return }
        guard let itemSeq = viewModel.inputItemSeq.value else { return}
        guard let data = dataSource.itemIdentifier(for: indexPath) else { return }
        
        FileDownloadManager.shared.downloadFile(url: data, pillID: itemSeq) { [weak self] response in
            guard let self = self else { return }
            switch response {
                
            case .success(let success):
                print(success, " - Collection View")
                self.sendData?(success)
            case .failure(let error):
                print(error)
            }
        }
        
        dismiss(animated: true)
        
    }
}
