//
//  ModelManager.swift
//  Do_Did_List
//
//  Created by 강민석 on 2020/03/18.
//  Copyright © 2020 MinseokKang. All rights reserved.
//

import Foundation
import RealmSwift

enum DateType {
    case today
    case thisMonth
    case allDate
    case customDate
}

class ModelManager {
    
    var realm: Realm!
    
    init() {
        realm = try! Realm()
    }
    
    /**
     realm 로컬 DB로 Item 추가(쓰기) 기능을 수행합니다.
     
     - Parameters:
     - item: DB에 추가할 아이템
     */
    func add(_ item: ToDoItem) {
        do {
            try realm.write {
                realm.add(item)
            }
        } catch {
            print("Faild to add!")
        }
    }
    
    func remove(_ item: ToDoItem) {
        do {
            try realm.write {
                realm.delete(item)
            }
        } catch {
            print("Faild to remove")
        }
    }
    
    
    /**
     realm의 db item 검색기능을 사용하여, 매개변수 date와 일치하는 날짜를 찾아서 결과를 반환합니다
     - Parameter date: 검색할 날짜
     */
    func searchDate(dateType: DateType, customDate: Date?) -> Results<ToDoItem> {
        let result: Results<ToDoItem>
        let date = Date()
        
        switch dateType {
        case .today:
            result = realm.objects(ToDoItem.self).filter(NSPredicate(format: "timestamp >= %@ && timestamp <= %@", date.startOfDay as NSDate, date.endOfDay as NSDate))
        case .thisMonth:
            result = realm.objects(ToDoItem.self).filter(NSPredicate(format: "timestamp >= %@ && timestamp <= %@", date.startOfMonth as NSDate, date.endOfMonth as NSDate))
        case .allDate:
            result = realm.objects(ToDoItem.self)
        case .customDate:
            guard let date = customDate else { fatalError() }
            result = realm.objects(ToDoItem.self).filter(NSPredicate(format: "timestamp >= %@ && timestamp <= %@", date.startOfDay as NSDate, date.endOfDay as NSDate))
        }
        
        return result
    }
    
    func filterDone(original: Results<ToDoItem>, isDone: Bool) -> Results<ToDoItem> {
        let result: Results<ToDoItem>
        
        switch isDone {
        case true:
            result = original.filter(NSPredicate(format: "isDone == true"))
        case false:
            result = original.filter(NSPredicate(format: "isDone == false"))
        }
        
        return result
    }
    
    func changeDoneCondition(item: ToDoItem, condition: Bool) {
        do {
            try realm.write {
                item.isDone = condition
            }
        } catch {
            print("Faild to change condition")
        }
    }
    
    
}

extension Date {
    var startOfDay: Date {
        return Calendar.current.startOfDay(for: self)
    }
    
    var endOfDay: Date {
        var components = DateComponents()
        components.day = 1
        components.second = -1
        return Calendar.current.date(byAdding: components, to: startOfDay)!
    }
    
    var startOfMonth: Date {
        let components = Calendar.current.dateComponents([.year, .month], from: startOfDay)
        return Calendar.current.date(from: components)!
    }
    
    var endOfMonth: Date {
        var components = DateComponents()
        components.month = 1
        components.second = -1
        return Calendar.current.date(byAdding: components, to: startOfMonth)!
    }
}
