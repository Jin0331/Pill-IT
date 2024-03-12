//
//  RegisterPillWebSearchCollectionViewCell.swift
//  Pill-IT
//
//  Created by JinwooLee on 3/12/24.
//

import UIKit
import SnapKit
import Then

class RegisterPillWebSearchCollectionViewCell: BaseCollectionViewCell {
    
    let webImage = UIImageView().then {
        $0.contentMode = .scaleAspectFill
    }
    
    override func configureHierarchy() {
        contentView.addSubview(webImage)
    }
    
    override func configureLayout() {
        webImage.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}
