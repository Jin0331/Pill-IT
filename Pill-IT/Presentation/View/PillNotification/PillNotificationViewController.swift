//
//  PillNotificationViewController.swift
//  Pill-IT
//
//  Created by JinwooLee on 3/10/24.
//

import Parchment
import UIKit


//class PillNotificationViewController: BaseViewController {
//    
//    let mainView = PillNotificationView()
//    
//    override func loadView() {
//        view = mainView
//        mainView.calendar.delegate = self
//    }
//    
//    override func viewDidLoad() {
//        
//        super.viewDidLoad()        
//        
//    }
//    
//    override func configureNavigation() {
//        super.configureNavigation()
//        
//        navigationItem.rightBarButtonItem = nil
//    }
//}
//
// 
//extension PillNotificationViewController : FSCalendarDelegate {
//    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
//        calendar.setCurrentPage(date, animated: true)
//    }
//}


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

class PillNotificationViewController: UIViewController {
    private let calendar: Calendar = .current
    private let pagingViewController = PagingViewController()

    override func viewDidLoad() {
        super.viewDidLoad()

        pagingViewController.register(CalendarPagingCell.self, for: CalendarItem.self)
        pagingViewController.menuItemSize = .fixed(width: 48, height: 58)
        pagingViewController.textColor = UIColor.gray

        // Add the paging view controller as a child view
        // controller and constrain it to all edges
        addChild(pagingViewController)
        view.addSubview(pagingViewController.view)
        view.constrainToEdges(pagingViewController.view)
        pagingViewController.didMove(toParent: self)

        // Set our custom data source
        pagingViewController.infiniteDataSource = self

        // Set the current date as the selected paging item.
        let today = calendar.startOfDay(for: Date())
        pagingViewController.select(pagingItem: CalendarItem(date: today))

        navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: "Today",
            style: .plain,
            target: self,
            action: #selector(selectToday))
    }

    @objc private func selectToday() {
        let date = calendar.startOfDay(for: Date())
        pagingViewController.select(pagingItem: CalendarItem(date: date), animated: true)
    }
}

// We need to conform to PagingViewControllerDataSource in order to
// implement our custom data source. We set the initial item to be the
// current date, and every time pagingItemBeforePagingItem: or
// pagingItemAfterPagingItem: is called, we either subtract or append
// the time interval equal to one day. This means our paging view
// controller will show one menu item for each day.
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
        
        print(calendarItem.date)
        
        return ContentViewController(title: formattedDate)
    }
}

