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
import Toast_Swift

final class RegisterPillWebSearchViewController: BaseViewController {
        
    weak var viewModel : RegisterPillViewModel?
    private var dataSource : UICollectionViewDiffableDataSource<RegisterPillWebSearchViewSection, URL>!
    var sendData : ((URL) -> Void)?
    
    // UI
    let titleLabel = UILabel().then {
        $0.textColor = DesignSystem.colorSet.black
        $0.font = .systemFont(ofSize: 22, weight: .heavy)
        $0.textAlignment = .center
    }
    private lazy var seaerchCollectionView : UICollectionView = {
        let view = UICollectionView(frame: .zero, collectionViewLayout: createLayout())
        view.backgroundColor = DesignSystem.colorSet.white
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
        
        viewModel.outputItemImageWebLink.bind { [weak self] _ in
            guard let self = self else { return }
            
            updateSnapshot()
        }
        
    }
    
    override func configureHierarchy() {
        view.addSubview(titleLabel)
        view.addSubview(seaerchCollectionView)
    }
    
    override func configureLayout() {
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).inset(20)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(40)
        }
        
        seaerchCollectionView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(15)
            make.bottom.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    override func configureView() {
        super.configureView()
        
        guard let viewModel = viewModel else { return }
        guard let title = viewModel.inputItemName.value else { return }
        
        titleLabel.text = "\(title) 검색 결과"
    }
    
    //MARK: - Modern collection View
    // Like 인스타그램
    // 출처: https://kangheeseon.tistory.com/16
    private func createLayout() -> UICollectionViewLayout {
        let fullPhotoItem = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalWidth(2/3)))
            fullPhotoItem.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0)
        
        let mainItem = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(2/3), heightDimension: .fractionalHeight(1.0)))
        mainItem.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0)
        
        let pairItem = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(0.5)))
        pairItem.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0)

        let trailingGroup = NSCollectionLayoutGroup.vertical(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1/3), heightDimension: .fractionalHeight(1.0)), subitem: pairItem, count: 2)
        let mainWithTrailingGroup = NSCollectionLayoutGroup.horizontal(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalWidth(4/9)), subitems: [mainItem, trailingGroup])

        let tripleItem = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1/3), heightDimension: .fractionalHeight(1.0)))
        tripleItem.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0)
        let tripleGroup = NSCollectionLayoutGroup.horizontal(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalWidth(2/9)), subitem: tripleItem, count: 3)
        

        let mainWithReversedGroup = NSCollectionLayoutGroup.horizontal(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalWidth(4/9)), subitems: [trailingGroup, mainItem])
        let nestedGroup = NSCollectionLayoutGroup.vertical(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalWidth(16/9)), subitems: [fullPhotoItem, mainWithTrailingGroup, tripleGroup, mainWithReversedGroup])
        let section = NSCollectionLayoutSection(group: nestedGroup)
        let layout = UICollectionViewCompositionalLayout(section: section)
        
        
        return layout
    }
    
    private func configureDataSource() {
        
        let cellRegistration = UICollectionView.CellRegistration<RegisterPillWebSearchCollectionViewCell, URL> { cell, indexPath, itemIdentifier in

            //TODO: - Kingfisher로 변경 필요
            let provider = LocalFileImageDataProvider(fileURL: itemIdentifier)
            cell.webImage.kf.indicatorType = .activity
            cell.webImage.kf.setImage(with: provider, options: [.transition(.fade(0.7))])
        }
        
        dataSource = UICollectionViewDiffableDataSource(collectionView: seaerchCollectionView, cellProvider: { collectionView, indexPath, itemIdentifier in
            let cell = collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: itemIdentifier)
            
            return cell
        })
    }

    private func updateSnapshot() {
        guard let viewModel = viewModel else { return }
        guard let outputItemImageWebLink = viewModel.outputItemImageWebLink.value else { print("안찍히냐");return }
        
        if outputItemImageWebLink.count < 1 {
            self.view.makeToast("이미지 검색 결과가 없어요 🥲", duration: 3.0, position: .center)
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 3.5) { [weak self] in
                self?.dismiss(animated: true)
            }
        }
        
        var snapshot = NSDiffableDataSourceSnapshot<RegisterPillWebSearchViewSection, URL>()
        snapshot.appendSections(RegisterPillWebSearchViewSection.allCases)
        snapshot.appendItems(outputItemImageWebLink, toSection: .main)
        dataSource.apply(snapshot) // reloadData
    }
    
    deinit {
        print(#function, " - ✅ RegisterPillWebSearchViewController")
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
