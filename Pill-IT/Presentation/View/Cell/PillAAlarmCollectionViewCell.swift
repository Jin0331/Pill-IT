//
//  PillAlarmCollectionViewCell.swift
//  Pill-IT
//
//  Created by JinwooLee on 3/16/24.
//

import UIKit
import SnapKit
import Then
import Kingfisher

class PillAlarmCollectionViewCell: BaseCollectionViewCell {
    
    let itemImage = UIImageView().then {
        $0.contentMode = .scaleToFill
        $0.layer.cornerRadius = DesignSystem.viewLayout.imageCornetRadius
        $0.clipsToBounds = true
    }
    
    let itemNameLabel = UILabel().then {
        $0.textColor = DesignSystem.colorSet.lightBlack
        $0.font = .systemFont(ofSize: 17, weight: .heavy)
        $0.numberOfLines = 0
    }
    
    override func configureHierarchy() {
        [itemImage, itemNameLabel].forEach {contentView.addSubview($0) }
    }
    
    override func configureLayout() {
        itemImage.snp.makeConstraints { make in
            make.size.equalTo(50)
            make.centerY.leading.equalTo(safeAreaLayoutGuide)
        }
        
        itemNameLabel.snp.makeConstraints { make in
            make.leading.equalTo(itemImage.snp.trailing).offset(20)
            make.trailing.equalTo(self.safeAreaLayoutGuide)
            make.height.equalTo(40)
            make.bottom.equalTo(itemImage.snp.bottom)
        }
    }
    
    override func prepareForReuse() {
        itemImage.image = nil
    }
    
    func updateUI(_ itemIdentifier : Pill) {
        
        print("🔆 cell updateUI")
        
        let provider = LocalFileImageDataProvider(fileURL: itemIdentifier.urlPathToURL)
        
        itemImage.kf.setImage(with: provider, options: [.transition(.fade(1))])
        itemNameLabel.text = itemIdentifier.itemName
    }
    
    deinit {
        print(#function, " - ✅ PillManagementCollectionViewcell")
    }
}
