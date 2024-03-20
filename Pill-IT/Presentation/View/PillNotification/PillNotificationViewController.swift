//
//  PillNotificationViewController.swift
//  Pill-IT
//
//  Created by JinwooLee on 3/20/24.
//

import UIKit
import Parchment
import SnapKit
import Then

final class PillNotificationViewController: BaseViewController {
    private let calendar: Calendar = .current
    private let pagingViewController = PagingViewController()
    private let dayOfWeek = UILabel().then {
        $0.text = "수요일"
        $0.textColor = DesignSystem.colorSet.black
        $0.font = .systemFont(ofSize: 35, weight: .heavy)
    }
    
    private let day = UILabel().then {
        $0.text = "3월 19일"
        $0.textColor = DesignSystem.colorSet.black
        $0.font = .systemFont(ofSize: 27, weight: .heavy)
    }
    
    private let todayButton = UIButton().then {
        $0.setImage(DesignSystem.sfSymbol.today, for: .normal)
        $0.tintColor = DesignSystem.colorSet.white
        $0.backgroundColor = DesignSystem.colorSet.lightBlack
        $0.layer.cornerRadius = DesignSystem.viewLayout.cornerRadius
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        pagingViewController.delegate = self
        pagingViewController.infiniteDataSource = self
    }
    
    override func configureHierarchy() {
        addChild(pagingViewController)
        [dayOfWeek, day, todayButton, pagingViewController.view].forEach { view.addSubview($0)}
        
    }
    
    override func configureLayout() {
        
        dayOfWeek.snp.makeConstraints { make in
            make.top.leading.equalTo(view.safeAreaLayoutGuide).inset(20)
            make.width.lessThanOrEqualTo(120)
        }
        
        day.snp.makeConstraints { make in
            make.top.equalTo(dayOfWeek.snp.bottom).offset(5)
            make.leading.equalTo(dayOfWeek)
            make.size.greaterThanOrEqualTo(dayOfWeek)
        }
        
        todayButton.snp.makeConstraints { make in
            make.top.equalTo(dayOfWeek)
            make.leading.equalTo(dayOfWeek.snp.trailing).offset(15)
            make.centerY.equalTo(dayOfWeek)
            make.size.equalTo(40)
        }
        
        pagingViewController.view.snp.makeConstraints { make in
            make.top.equalTo(day.snp.bottom).offset(10)
            make.bottom.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    override func configureView() {
        super.configureView()
        pagingViewController.register(PillNotificationItemMenuCollectionViewCell.self, for: CalendarItem.self)
        pagingViewController.menuItemSize = .fixed(width: 48, height: 58)
        pagingViewController.textColor = UIColor.gray
        pagingViewController.didMove(toParent: self)
        pagingViewController.indicatorColor = DesignSystem.colorSet.lightBlack
        pagingViewController.menuInteraction = .none
        pagingViewController.contentInteraction = .none // !!! 메뉴에서만 스크롤 가능
        
        // Set the current date as the selected paging item.
        let today = calendar.startOfDay(for: Date())
        pagingViewController.select(pagingItem: CalendarItem(date: today))
        updateDateUI(CalendarItem(date: today))
        todayButton.addTarget(self, action: #selector(selectToday), for: .touchUpInside)
    }
    
    @objc private func selectToday() {
        let date = calendar.startOfDay(for: Date())
        pagingViewController.select(pagingItem: CalendarItem(date: date), animated: true)
    }
}

//MARK: - Parchment Delegate, DataSoruce
extension PillNotificationViewController: PagingViewControllerInfiniteDataSource, PagingViewControllerDelegate {

    
    func pagingViewController(_: PagingViewController, itemAfter pagingItem: PagingItem) -> PagingItem? {
        let calendarItem = pagingItem as! CalendarItem
        let nextDate = calendar.date(byAdding: .day, value: 1, to: calendarItem.date)!
        
        return CalendarItem(date: nextDate)
    }
    
    func pagingViewController(_: PagingViewController, itemBefore pagingItem: PagingItem) -> PagingItem? {
        let calendarItem = pagingItem as! CalendarItem
        let previousDate = calendar.date(byAdding: .day, value: -1, to: calendarItem.date)!
        
        return CalendarItem(date: previousDate)
    }
        
    func pagingViewController(_ pagingViewController: PagingViewController, didScrollToItem pagingItem: any PagingItem, startingViewController: UIViewController?, destinationViewController: UIViewController, transitionSuccessful: Bool) {
        let calendarItem = pagingItem as! CalendarItem
        updateDateUI(calendarItem)
    }
    
    func pagingViewController(_: PagingViewController, viewControllerFor pagingItem: PagingItem) -> UIViewController {
        let calendarItem = pagingItem as! CalendarItem
        let vc = PillNotificationContentViewController(currentDate: calendarItem.date)
        
        return vc
    }
    
    private func updateDateUI(_ calendarItem : CalendarItem) {
        let dayOfWeekDate = DateFormatters.weekdayFullFormatter.string(from: calendarItem.date)
        let dayDate = DateFormatters.dateFullFormatter.string(from: calendarItem.date)
        
        dayOfWeek.text = dayOfWeekDate
        day.text = dayDate
    }
}
