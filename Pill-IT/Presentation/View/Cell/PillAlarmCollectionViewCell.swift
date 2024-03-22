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
import MarqueeLabel

final class PillAlarmCollectionViewCell: BaseCollectionViewCell {
    
    let bgView = UIView().then {
        $0.layer.cornerRadius = DesignSystem.viewLayout.cornerRadius
        $0.layer.shadowOffset = CGSize(width: 1, height: 2)
        $0.layer.shadowOpacity = 0.05
        $0.layer.shadowRadius = 10
        $0.layer.masksToBounds = false
        $0.backgroundColor = .white
    }
    
    let itemImage = UIImageView().then {
        $0.contentMode = .scaleToFill
        $0.layer.cornerRadius = DesignSystem.viewLayout.imageCornetRadius
        $0.clipsToBounds = true
    }
    
    let itemNameLabel = MarqueeLabel().then {
        $0.textColor = DesignSystem.colorSet.lightBlack
        $0.font = .systemFont(ofSize: 17, weight: .heavy)
        $0.numberOfLines = 0
    }
    
    override func configureHierarchy() {
        contentView.addSubview(bgView)
        [itemImage, itemNameLabel].forEach {
            bgView.addSubview($0)
        }
    }
    
    override func configureLayout() {
        
        bgView.snp.makeConstraints { make in
            make.verticalEdges.equalTo(contentView.safeAreaLayoutGuide)
            make.horizontalEdges.equalTo(contentView.safeAreaLayoutGuide)
        }
        
        itemImage.snp.makeConstraints { make in
            make.leading.top.bottom.equalTo(bgView).inset(5)
//            make.height.equalTo(40)
            make.width.equalTo(50)
        }
        
        itemNameLabel.snp.makeConstraints { make in
            make.leading.equalTo(itemImage.snp.trailing).offset(5)
            make.trailing.equalTo(bgView)
            make.centerY.equalTo(itemImage)
        }
    }
    
    override func prepareForReuse() {
        itemImage.image = nil
    }
    
    func updateUI(_ itemIdentifier : Pill) {
        
        print("🔆 PillAlarmCollectionViewCell updateUI")
        
        let provider = LocalFileImageDataProvider(fileURL: itemIdentifier.urlPathToURL)
        
        itemImage.kf.setImage(with: provider, options: [.transition(.fade(1))])
        itemNameLabel.text = itemIdentifier.itemName
    }
    
    deinit {
        print(#function, " - ✅ PillManagementCollectionViewcell")
    }
}
