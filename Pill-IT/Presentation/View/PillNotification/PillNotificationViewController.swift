//
//  PillNotificationViewController.swift
//  Pill-IT
//
//  Created by JinwooLee on 3/10/24.
//

import UIKit
import Parchment
import SnapKit

struct CalendarItem: PagingItem, Hashable, Comparable {
    let date: Date
    let dateText: String
    let weekdayText: String

    init(date: Date) {
        self.date = date
        dateText = DateFormatters.dateFormatter.string(from: date)
        weekdayText = DateFormatters.weekdayFormatter.string(from: date)
    }

    static func < (lhs: CalendarItem, rhs: CalendarItem) -> Bool {
        return lhs.date < rhs.date
    }
}

final class PillNotificationViewController: BaseViewController {
    private let calendar: Calendar = .current
    private let pagingViewController = PagingViewController()

    override func viewDidLoad() {
        super.viewDidLoad()

        pagingViewController.infiniteDataSource = self
    }
    
    override func configureHierarchy() {
        addChild(pagingViewController)
        
        view.addSubview(pagingViewController.view)
    }
    
    override func configureLayout() {
        pagingViewController.view.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    override func configureView() {
        super.configureView()
        pagingViewController.register(PillNotificationCell.self, for: CalendarItem.self)
        pagingViewController.menuItemSize = .fixed(width: 48, height: 58)
        pagingViewController.textColor = UIColor.gray
        pagingViewController.didMove(toParent: self)
        pagingViewController.indicatorColor = DesignSystem.colorSet.lightBlack
        pagingViewController.contentInteraction = .none // !!! 메뉴에서만 스크롤 가능
        
        // Set the current date as the selected paging item.
        let today = calendar.startOfDay(for: Date())
        pagingViewController.select(pagingItem: CalendarItem(date: today))
    }
    
    @objc private func selectToday() {
        let date = calendar.startOfDay(for: Date())
        pagingViewController.select(pagingItem: CalendarItem(date: date), animated: true)
    }
}

extension PillNotificationViewController: PagingViewControllerInfiniteDataSource {
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

    func pagingViewController(_: PagingViewController, viewControllerFor pagingItem: PagingItem) -> UIViewController {
        let calendarItem = pagingItem as! CalendarItem
        let formattedDate = DateFormatters.shortDateFormatter.string(from: calendarItem.date)
        
        print(calendarItem.date, "🥲🥲🥲🥲")
        
        return PillNotificationContentViewController(title: formattedDate)
    }
}

