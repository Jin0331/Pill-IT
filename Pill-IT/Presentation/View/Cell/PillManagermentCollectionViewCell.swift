//
//  PillManagermentCollectionViewCell.swift
//  Pill-IT
//
//  Created by JinwooLee on 3/13/24.
//

import UIKit
import SnapKit
import Then

class PillManagermentCollectionViewCell: BaseCollectionViewCell {
    
    let bgView = UIView().then {
        $0.layer.cornerRadius = DesignSystem.viewLayout.cornerRadius
        $0.layer.masksToBounds = true
        $0.backgroundColor = .blue
    }
    
    let itemImage = UIImageView().then {
        $0.contentMode = .scaleAspectFit
        $0.layer.cornerRadius = DesignSystem.viewLayout.imageCornetRadius
        $0.clipsToBounds = true
        
        $0.backgroundColor = .red
    }
    
    let itemNameLabel = UILabel().then {
        $0.text = "타이레놀"
        $0.textColor = DesignSystem.colorSet.black
        $0.font = .systemFont(ofSize: 25, weight: .heavy)
    }
    
    let entpNameLabel = UILabel().then {
        $0.text = "유한양행"
        $0.textColor = DesignSystem.colorSet.gray
        $0.font = .systemFont(ofSize: 20, weight: .heavy)
    }
    
    let productTypeLabel = UILabel().then {
        $0.text = "유한양행"
        $0.textColor = DesignSystem.colorSet.gray
        $0.font = .systemFont(ofSize: 20, weight: .heavy)
    }
    
    override func configureHierarchy() {
        contentView.addSubview(bgView)
        [itemImage, itemNameLabel, entpNameLabel, productTypeLabel].forEach {
            bgView.addSubview($0)
        }
    }
    
    override func configureLayout() {
        bgView.snp.makeConstraints { make in
            make.edges.equalTo(contentView.safeAreaLayoutGuide)
        }
        
        itemImage.snp.makeConstraints { make in
            make.top.leading.equalTo(bgView).inset(10)
            make.size.equalTo(80)
        }
        
        itemNameLabel.snp.makeConstraints { make in
            make.top.equalTo(itemImage).inset(5)
            make.leading.equalTo(itemImage.snp.trailing).offset(10)
            make.height.equalTo(30)
            make.trailing.equalTo(bgView)
        }
        
        entpNameLabel.snp.makeConstraints { make in
            make.top.equalTo(itemNameLabel).inset(5)
            make.horizontalEdges.equalTo(itemNameLabel)
            make.height.equalTo(30)
        }
        
        productTypeLabel.snp.makeConstraints { make in
            make.top.equalTo(entpNameLabel).inset(5)
            make.horizontalEdges.equalTo(itemNameLabel)
            make.height.equalTo(20)
        }
    }
    
    override func prepareForReuse() {
        itemImage.image = nil
    }
    
}
