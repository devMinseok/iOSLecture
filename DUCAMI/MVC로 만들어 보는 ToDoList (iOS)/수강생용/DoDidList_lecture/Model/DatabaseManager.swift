//
//  DatabaseManager.swift
//  DoDidList_lecture
//
//  Created by 강민석 on 2020/12/22.
//

import Foundation
import RealmSwift

enum DateType {
    case today
    case thisMonth
    case allDate
    case customDate
}

class DatabaseManager {
    
    static let shared = DatabaseManager()
    
    private let realm: Realm
    
    private init() {
        self.realm = try! Realm()
    }
    
    /**
     realm 로컬 DB로 Item 추가(쓰기) 기능을 수행합니다.
     
     - Parameters:
     - item: DB에 추가할 아이템
     */
    func add<T: Object>(_ item: T) {
        do {
            try realm.write {
                realm.add(item)
            }
        } catch {
            print("Faild to add!")
        }
    }
    
    func remove<T: Object>(_ item: T) {
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
    func searchDate<T: Object>(dateType: DateType, customDate: Date?, type: T.Type) -> Results<T> {
        let result: Results<T>
        let date = Date()
        
        switch dateType {
        case .today:
            result = realm.objects(T.self).filter(NSPredicate(format: "timestamp >= %@ && timestamp <= %@", date.startOfDay as NSDate, date.endOfDay as NSDate))
        case .thisMonth:
            result = realm.objects(T.self).filter(NSPredicate(format: "timestamp >= %@ && timestamp <= %@", date.startOfMonth as NSDate, date.endOfMonth as NSDate))
        case .allDate:
            result = realm.objects(T.self)
        case .customDate:
            guard let date = customDate else { fatalError() }
            result = realm.objects(T.self).filter(NSPredicate(format: "timestamp >= %@ && timestamp <= %@", date.startOfDay as NSDate, date.endOfDay as NSDate))
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
