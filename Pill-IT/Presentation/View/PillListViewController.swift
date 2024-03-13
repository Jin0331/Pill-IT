//
//  PillListViewController.swift
//  Pill-IT
//
//  Created by JinwooLee on 3/10/24.
//

import UIKit
import SearchTextField
import SnapKit
import Then

class PillListViewController: BaseViewController {

    let userInputTextfield = SearchTextField().then {
        $0.attributedPlaceholder = NSAttributedString(string: "복용중인 약을 입력해주세요", attributes: [NSAttributedString.Key.foregroundColor : DesignSystem.colorSet.lightBlack])
        $0.addLeftPadding()
        $0.clearButtonMode = .always
        $0.font = .systemFont(ofSize: 23, weight: .heavy)
        $0.textColor = DesignSystem.colorSet.black
        $0.layer.borderWidth = DesignSystem.viewLayout.borderWidth
        $0.layer.borderColor = DesignSystem.colorSet.lightBlack.cgColor
        $0.layer.cornerRadius = DesignSystem.viewLayout.cornerRadius
        
        
        $0.theme.font = .systemFont(ofSize: 15)
        $0.highlightAttributes = [NSAttributedString.Key.backgroundColor: DesignSystem.colorSet.lightGray, NSAttributedString.Key.font:UIFont.systemFont(ofSize: 15, weight: .heavy),
                                  NSAttributedString.Key.foregroundColor : DesignSystem.colorSet.purple.cgColor]
        $0.theme.bgColor = DesignSystem.colorSet.lightGray
        $0.theme.borderColor = DesignSystem.colorSet.lightBlack
        $0.theme.borderWidth = DesignSystem.viewLayout.borderWidth
        $0.theme.cellHeight = 50
        $0.forceNoFiltering = false
        $0.minCharactersNumberToStartFiltering = 2
        $0.comparisonOptions = [.caseInsensitive]
        $0.hideResultsList()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        
        let item1 = SearchTextFieldItem(title: "Blue", subtitle: "Color", image: UIImage(named: "icon_blue"))
        let item2 = SearchTextFieldItem(title: "Red", subtitle: "Color", image: UIImage(named: "icon_red"))
        let item3 = SearchTextFieldItem(title: "Yellow", subtitle: "Color", image: UIImage(named: "icon_yellow"))
        userInputTextfield.filterItems([item1, item2, item3])
        
    }
    
    
    override func configureHierarchy() {
        view.addSubview(userInputTextfield)
    }
    
    override func configureLayout() {
        userInputTextfield.snp.makeConstraints { make in
            make.top.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(70)
        }
    }
    
    override func configureView() {
        view.backgroundColor = .blue
    }
}
