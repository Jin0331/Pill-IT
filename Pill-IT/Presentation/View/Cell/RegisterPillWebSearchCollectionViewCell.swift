//
//  RegisterPillWebSearchCollectionViewCell.swift
//  Pill-IT
//
//  Created by JinwooLee on 3/12/24.
//

import UIKit
import SnapKit
import Then
import Kingfisher

final class RegisterPillWebSearchCollectionViewCell: BaseCollectionViewCell {
    
    let webImage = UIImageView().then { _ in
    }
    
    override func configureHierarchy() {
        contentView.addSubview(webImage)
    }
    
    override func configureLayout() {
        webImage.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    override func prepareForReuse() {
        webImage.image = nil
    }
    
    func updateUI(_ itemIdentifier : URL) {
        //TODO: - Kingfisher로 변경 필요
        let provider = LocalFileImageDataProvider(fileURL: itemIdentifier)
        webImage.kf.indicatorType = .activity
        webImage.kf.setImage(with: provider, options: [.transition(.fade(0.7))])
    }
}
