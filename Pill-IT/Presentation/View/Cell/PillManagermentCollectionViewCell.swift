//
//  PillManagementCollectionViewCell.swift
//  Pill-IT
//
//  Created by JinwooLee on 3/13/24.
//

import UIKit
import SnapKit
import Then
import Kingfisher

class PillManagementCollectionViewCell: BaseCollectionViewCell {
    
    let bgView = UIView().then {
        $0.layer.cornerRadius = DesignSystem.viewLayout.cornerRadius
        $0.layer.shadowOffset = CGSize(width: 10, height: 5)
        $0.layer.shadowOpacity = 0.2
        $0.layer.shadowRadius = 10
        $0.layer.masksToBounds = false
        
        
        $0.backgroundColor = .white
    }
    
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
    
    let entpNameLabel = UILabel().then {
        $0.textColor = DesignSystem.colorSet.gray
        $0.font = .systemFont(ofSize: 13, weight: .heavy)
    }
    
    let productTypeLabel = UILabel().then {
        $0.textColor = DesignSystem.colorSet.gray
        $0.font = .systemFont(ofSize: 13, weight: .heavy)
        $0.numberOfLines = 0
        
    }
    
    let selectedImage = UIImageView().then {
        $0.image = UIImage(named: "check")
        $0.alpha = 0.75
        $0.isHidden = true
    }
    
    override func configureHierarchy() {
        contentView.addSubview(bgView)
        [itemImage, itemNameLabel, entpNameLabel, productTypeLabel, selectedImage].forEach {
            bgView.addSubview($0)
        }
    }
    
    override func configureLayout() {
        bgView.snp.makeConstraints { make in
            make.verticalEdges.equalTo(contentView.safeAreaLayoutGuide)
            make.horizontalEdges.equalTo(contentView.safeAreaLayoutGuide).inset(10)
        }
        
        itemImage.snp.makeConstraints { make in
            make.verticalEdges.leading.equalTo(bgView).inset(20)
            make.width.equalTo(150)
        }
        
        itemNameLabel.snp.makeConstraints { make in
            make.top.equalTo(itemImage).inset(5)
            make.leading.equalTo(itemImage.snp.trailing).offset(10)
            make.height.greaterThanOrEqualTo(50)
            make.trailing.equalTo(bgView)
        }
        
        entpNameLabel.snp.makeConstraints { make in
            make.top.equalTo(itemNameLabel.snp.bottom).offset(2)
            make.horizontalEdges.equalTo(itemNameLabel)
            make.height.equalTo(30)
        }
        
        productTypeLabel.snp.makeConstraints { make in
            make.top.equalTo(entpNameLabel.snp.bottom).offset(5)
            make.horizontalEdges.equalTo(itemNameLabel)
            make.bottom.lessThanOrEqualTo(bgView.snp.bottom).inset(20)
//            make.bottom.equalTo(bgView.snp.bottom).inset(10)
        }
        
        selectedImage.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.size.equalTo(itemImage.snp.height).multipliedBy(0.75)
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
        entpNameLabel.text = itemIdentifier.entpName
        productTypeLabel.text = itemIdentifier.prductType
    }
    
    func showSelectedImage() {
        selectedImage.isHidden = false
    }
    
    func hiddneSelectedImage() {
        selectedImage.isHidden = true
    }
    
    deinit {
        print(#function, " - ✅ PillManagementCollectionViewcell")
    }

}
