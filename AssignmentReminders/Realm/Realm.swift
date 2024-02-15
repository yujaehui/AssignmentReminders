//
//  Realm.swift
//  AssignmentReminders
//
//  Created by Jaehui Yu on 2/15/24.
//

import Foundation
import RealmSwift

/*
 정규화
 
 PK
 제목: Stirng
 메모: Stirng?
 날짜: Date?
 태그: String?
 깃발: Bool
 중요도: Int?
 진행 여부: Bool
 마감 여부: Bool
 생성일
 */

class Reminder: Object {
    @Persisted(primaryKey: true) var id: ObjectId
    @Persisted var title: String
    @Persisted var notes: String?
    @Persisted var date: Date?
    @Persisted var tag: String?
    @Persisted var flag: Bool
    @Persisted var priority: String?
    @Persisted var isCompleted: Bool
    @Persisted var isClosed: Bool?
    @Persisted var CreationDate: Date
    
    convenience init(title: String, notes: String? = nil, date: Date? = nil, tag: String? = nil, flag: Bool, priority: String? = nil, isCompleted: Bool, isClosed: Bool? = nil, CreationDate: Date) {
        self.init()
        self.title = title
        self.notes = notes
        self.date = date
        self.tag = tag
        self.flag = flag
        self.priority = priority
        self.isCompleted = isCompleted
        self.isClosed = isClosed
        self.CreationDate = CreationDate
    }
}
