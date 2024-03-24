//
//  PillAlarmReviseViewController.swift
//  Pill-IT
//
//  Created by JinwooLee on 3/22/24.
//

import UIKit
import Tabman
import Pageboy

final class PillAlarmReviseViewController: TabmanViewController, TMBarDataSource {

    var viewModel = PillAlaramRegisterViewModel()
    private var viewControllers: Array<UIViewController> = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
           
        let itemEditVC = PillAlarmReviseItemViewController()
        let dataEditVC = PillAlarmReviseDateViewController()
        
        itemEditVC.viewModel = viewModel
        dataEditVC.viewModel = viewModel
        
        viewControllers.append(itemEditVC)
        viewControllers.append(dataEditVC)
        
        configureView()
        configureNavigation()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        configureNavigation()
    }
    
    deinit {
        print(#function, "- ✅ PillAlarmReviseViewController")
    }

}

//MARK: - Tabman 관련 사항
extension PillAlarmReviseViewController : PageboyViewControllerDataSource {
    func barItem(for bar: TMBar, at index: Int) -> TMBarItemable {
        let item = TMBarItem(title: "")
        item.title = index == 0 ? "알림 수정" : "알림 시간 수정"
        
        return item
    }
    
    func numberOfViewControllers(in pageboyViewController: PageboyViewController) -> Int {
        return viewControllers.count
    }

    func viewController(for pageboyViewController: PageboyViewController,
                        at index: PageboyViewController.PageIndex) -> UIViewController? {
        return viewControllers[index]
    }

    func defaultPage(for pageboyViewController: PageboyViewController) -> PageboyViewController.Page? {
        return nil
    }
    
}

//MARK: - 화면 디자인
extension PillAlarmReviseViewController {
    private func configureView() {
        view.backgroundColor = DesignSystem.colorSet.white
        
        dataSource = self
        let bar = TMBar.ButtonBar()
        bar.buttons.customize { (button) in
            button.tintColor = DesignSystem.colorSet.gray
            button.selectedTintColor = DesignSystem.colorSet.lightBlack
        }
    
        
        bar.layout.transitionStyle = .snap // Customize
        bar.layout.contentMode = .fit
        bar.layout.interButtonSpacing = 20 // 버튼 사이의 간격 조절
        addBar(bar, dataSource: self, at: .top)
    }
    
    private func configureNavigation() {
        
        // bottom border
        navigationController?.navigationBar.scrollEdgeAppearance?.backgroundColor = DesignSystem.colorSet.white
        navigationController?.navigationBar.barTintColor = DesignSystem.colorSet.white
        
        // title 크게
        navigationItem.title = "⚠️" + viewModel.inputGroupId.value! + " - 수정하기"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.largeTitleTextAttributes =  [NSAttributedString.Key.foregroundColor: DesignSystem.colorSet.lightBlack,
                                                                         NSAttributedString.Key.font: UIFont.systemFont(ofSize: 22, weight: .heavy)]
        
        navigationController?.navigationBar.titleTextAttributes =  [NSAttributedString.Key.foregroundColor: DesignSystem.colorSet.lightBlack]
        
        let deleteButton = UIButton(frame: CGRect(x: 0, y: 20, width: 130, height: 40)).then {
            $0.setTitle(" 알림 삭제하기", for: .normal)
            $0.titleLabel?.font = .systemFont(ofSize: 15, weight: .heavy)
            $0.setTitleColor(DesignSystem.colorSet.white, for: .normal)
            $0.tintColor = DesignSystem.colorSet.white
            $0.backgroundColor = DesignSystem.colorSet.red
            $0.setImage(DesignSystem.sfSymbol.trash, for: .normal)
            $0.layer.cornerRadius = DesignSystem.viewLayout.cornerRadius
            $0.layer.shadowOffset = CGSize(width: 10, height: 5)
            $0.layer.shadowOpacity = 0.1
            $0.layer.shadowRadius = 10
            $0.layer.masksToBounds = false
        }
        
        deleteButton.addTarget(self, action: #selector(leftBarButtonClicked), for: .touchUpInside)
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: deleteButton)
        
        // right button
        let cancleBarButton = UIBarButtonItem(image: DesignSystem.sfSymbol.cancel, style: .plain, target: self, action: #selector(rightBarButtonClicked))
        navigationItem.rightBarButtonItem = cancleBarButton
    }
    
    @objc private func leftBarButtonClicked() {
        let confirmAction = UIAlertAction(title: "지워주세요", style: .default) {[weak self] (action) in
            guard let self = self else { return }
            
            viewModel.reviseAlarmRemoveTrigger.value = viewModel.outputGroupId.value
            NotificationCenter.default.post(name: Notification.Name("fetchPillAlarmTable"), object: nil)
            
            dismiss(animated: true)
        }
        
        let cancelAction = UIAlertAction(title: "취소할래요", style: .cancel)
        confirmAction.setValue(UIColor.red, forKey: "titleTextColor")
        
        self.showAlert(title: "등록된 복용약 알림 삭제", message: "등록된 복용약 알림을 삭제하시겠습니까? 🥲", actions: [confirmAction, cancelAction])
    }
    
    @objc private func rightBarButtonClicked() {
        dismiss(animated: true)
    }
}


