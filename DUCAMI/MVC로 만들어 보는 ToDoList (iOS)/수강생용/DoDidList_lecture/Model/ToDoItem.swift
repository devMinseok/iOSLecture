//
//  ToDoItem.swift
//  DoDidList_lecture
//
//  Created by 강민석 on 2020/12/22.
//

import Foundation
import RealmSwift

class ToDoItem: Object {
    
    @objc dynamic var id: String = UUID().uuidString // 고유 아이디
    
    // icon 관련 데이터
    @objc dynamic var firstColor: String = ""
    @objc dynamic var secondColor: String = ""
    @objc dynamic var imageData: Data = Data()
    
    @objc dynamic var title: String = "" // 매인 타이틀
    @objc dynamic var content: String = "" // 내용
    @objc dynamic var timestamp: Date = Date() // 날짜, 시간
    @objc dynamic var importance: Double = 0.0 // 0.0 ~ 3.0
    
    @objc dynamic var isDone: Bool = false // 완료 여부
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
    convenience init(title: String, firstColor: String, secondColor: String, imageData: Data, timestamp: Date, importance: Double, content: String, isDone: Bool) {
        self.init()

        self.title = title

        self.firstColor = firstColor
        self.secondColor = secondColor
        self.imageData = imageData

        self.timestamp = timestamp
        self.importance = importance
        self.content = content

        self.isDone = isDone
    }
}
