//
//  CalendarViewController.swift
//  Do_Did_List
//
//  Created by 강민석 on 2020/05/01.
//  Copyright © 2020 MinseokKang. All rights reserved.
//

import UIKit
import RealmSwift
import FSCalendar

class CalendarViewController: UIViewController {
    
    let modelManager = ModelManager()
    var items: Results<ToDoItem>?
    
    @IBOutlet weak var calendarView: FSCalendar!
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var calendarHeightConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        calendarView.delegate = self
        calendarView.dataSource = self
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "ToDoHistoryCell", bundle: nil), forCellReuseIdentifier: "ToDoHistoryCell")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        calendarView.select(Date())
        itemUpdate(dateType: .today, customDate: nil, reloadTableViewDuration: 0.6)
    }
    
    @IBAction func toggleButton(_ sender: Any) {
        if self.calendarView.scope == .month {
            self.calendarView.setScope(.week, animated: true)
        } else {
            self.calendarView.setScope(.month, animated: true)
        }
    }
    
    func itemUpdate(dateType: DateType, customDate: Date?, reloadTableViewDuration duration: TimeInterval) {
        
        items = modelManager.searchDate(dateType: dateType, customDate: customDate)
        items = items?.sorted(byKeyPath: "timestamp", ascending: true)
        
        UIView.transition(with: tableView.self, duration: duration, options: .transitionCrossDissolve, animations: { self.tableView.reloadData() })
    }
}

extension CalendarViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
}

extension CalendarViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoHistoryCell") as! ToDoHistoryCell
        
        let item = items?[indexPath.row]
        
        cell.titleLabel.text = item?.title
        cell.setTime(timestamp: item!.timestamp)
        cell.starRatingView.rating = item?.importance ?? 0
        cell.setIcon(imageData: item!.imageData)
        cell.setCheckbox(isDone: item!.isDone)
        
        return cell
    }
    
}

extension CalendarViewController: FSCalendarDelegate {
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        
        itemUpdate(dateType: .customDate, customDate: date, reloadTableViewDuration: 0.3)
    }
    
    func calendar(_ calendar: FSCalendar, boundingRectWillChange bounds: CGRect, animated: Bool) {
        self.calendarHeightConstraint.constant = bounds.height
        self.view.layoutIfNeeded()
    }
}

extension CalendarViewController: FSCalendarDataSource {
    
}
