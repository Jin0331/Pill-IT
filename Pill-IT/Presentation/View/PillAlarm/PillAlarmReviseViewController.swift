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
        
        viewControllers.append(itemEditVC)
        viewControllers.append(dataEditVC)
        
        configureView()
        configureNavigation()
    }
    
    deinit {
        print(#function, "- ✅ PillAlarmReviseViewController")
    }

}

extension PillAlarmReviseViewController : PageboyViewControllerDataSource {
    func barItem(for bar: TMBar, at index: Int) -> TMBarItemable {
        let item = TMBarItem(title: "")
        item.title = "Page \(index)"
        item.image = UIImage(named: "image.png")
        // ↑↑ 이미지는 이따가 탭바 형식으로 보여줄 때 사용할 것이니 "이미지가 왜 있지?" 하지말고 넘어가주세요.
        
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
        let bar = TMBar.TabBar()
        bar.layout.transitionStyle = .snap // Customize
        addBar(bar, dataSource: self, at: .top)
    }
    
    private func configureNavigation() {
        
        // bottom border
        navigationController?.navigationBar.scrollEdgeAppearance?.backgroundColor = DesignSystem.colorSet.white
        navigationController?.navigationBar.barTintColor = DesignSystem.colorSet.white
        
        // title 크게
        navigationItem.title = "⚠️ 복용약 알림 수정하기"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.largeTitleTextAttributes =  [NSAttributedString.Key.foregroundColor: DesignSystem.colorSet.lightBlack,                                                                         NSAttributedString.Key.font: UIFont.systemFont(ofSize: 30, weight: .heavy)]
        
        navigationController?.navigationBar.titleTextAttributes =  [NSAttributedString.Key.foregroundColor: DesignSystem.colorSet.lightBlack]
        
        let cancleBarButton = UIBarButtonItem(image: DesignSystem.sfSymbol.cancel, style: .plain, target: self, action: #selector(rightBarButtonClicked))
        
        navigationItem.rightBarButtonItem = cancleBarButton
    }
    
    @objc private func rightBarButtonClicked() {
        print("ASDasdzxcad  🥲")
        dismiss(animated: true)
    }
}


