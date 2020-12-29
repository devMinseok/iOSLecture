//
//  DoViewController.swift
//  Do_Did_List
//
//  Created by 강민석 on 2020/12/18.
//  Copyright © 2020 MinseokKang. All rights reserved.
//

import UIKit
import Foundation
import RealmSwift
import VerticalCardSwiper

class DoViewController: UIViewController {
    
    @IBOutlet weak var cardSwiper: VerticalCardSwiper!
    
    let modelManager = ModelManager()
    var items: Results<ToDoItem>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        UIApplication.shared.applicationIconBadgeNumber = 0
        
        cardSwiper.delegate = self
        cardSwiper.datasource = self
        
        cardSwiper.register(nib: UINib(nibName: "ToDoCardCell", bundle: nil), forCellWithReuseIdentifier: "ToDoCell")
        
        setNavigationBar()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        items = modelManager.searchDate(dateType: .today, customDate: nil)
        items = modelManager.filterDone(original: items!, isDone: false)
        items = items?.sorted(byKeyPath: "timestamp", ascending: true)
        
        UIView.transition(with: cardSwiper.self, duration: 0.5, options: .transitionCrossDissolve, animations: { self.cardSwiper.reloadData() })
        
        setNavigationTitle()
    }
    
    @objc func moveToCalendarView() {
        print("move to calendar view")
        self.tabBarController?.selectedIndex = 3
    }
    
    func setNavigationBar() {
        let textColor = UIColor(red: 0.23, green: 0.42, blue: 0.92, alpha: 1.00)
        
        let appearance = UINavigationBarAppearance()
        appearance.configureWithDefaultBackground()
        
        appearance.largeTitleTextAttributes = [
            .foregroundColor: textColor,
            .font: UIFont(name: "Fivo Sans", size: 35)!
        ]
        
        appearance.buttonAppearance.normal.titleTextAttributes = [
            .foregroundColor: textColor,
            .font: UIFont(name: "Fivo Sans", size: 18)!
        ]
        
        self.navigationItem.standardAppearance = appearance
        self.navigationItem.compactAppearance = appearance
        self.navigationItem.scrollEdgeAppearance = appearance
        
        navigationController?.navigationBar.prefersLargeTitles = true
        
        let leftButton = UIBarButtonItem(
            title: setDate(),
            style: .plain,
            target: self,
            action: #selector(moveToCalendarView)
        )
        
        navigationItem.setLeftBarButton(leftButton, animated: true)
    }
    
    func setNavigationTitle() {
        if ((items?.first) != nil) {
            self.navigationItem.title = "What To Do Today"
        } else {
            self.navigationItem.title = "Let's Do!"
        }
    }
    
    func setDate() -> String {
        let date = Date()
        let calendar = Calendar.current
        
        let weekNumber = calendar.component(.weekday, from: date)
        let weekName = DateFormatter().weekdaySymbols[weekNumber - 1]
        
        let monthNumber = calendar.component(.month, from: date)
        let monthName = DateFormatter().monthSymbols[monthNumber - 1]
        
        let dayNumber = calendar.component(.day, from: date)
        
        return "\(weekName) \(monthName) \(String(dayNumber))" // "WeekName + MonthName + DayNumber"
    }
}

extension DoViewController: VerticalCardSwiperDatasource {
    func numberOfCards(verticalCardSwiperView: VerticalCardSwiperView) -> Int {
        return items?.count ?? 0
    }
    
    func cardForItemAt(verticalCardSwiperView: VerticalCardSwiperView, cardForItemAt index: Int) -> CardCell {
        if let cardCell = verticalCardSwiperView.dequeueReusableCell(withReuseIdentifier: "ToDoCell", for: index) as? ToDoCardCell {
            let item = items?[index]
            
            cardCell.setBackgroundColor(item?.firstColor, item?.secondColor)
            cardCell.setImportance(ratingCount: item?.importance ?? 0)
            cardCell.setDate(date: item?.timestamp ?? Date())
            cardCell.setDescriptionTextView(text: item?.content ?? "")
            cardCell.setTitleLabel(title: item?.title ?? "")
            cardCell.setIconImage(item!.imageData)
            
            return cardCell
        }
        return CardCell()
    }
}

extension DoViewController: VerticalCardSwiperDelegate {
    func willSwipeCardAway(card: CardCell, index: Int, swipeDirection: SwipeDirection) {
        let item = items?[index]
        
        switch swipeDirection {
        case .Left:
            modelManager.remove(item!)
        case .Right:
            modelManager.changeDoneCondition(item: item!, condition: true)
        case .None:
            break
        }
    }
    
    func didSwipeCardAway(card: CardCell, index: Int, swipeDirection: SwipeDirection) {
        setNavigationTitle()
    }
    
    func didTapCard(verticalCardSwiperView: VerticalCardSwiperView, index: Int) {
        print("Tapped")
    }
}
