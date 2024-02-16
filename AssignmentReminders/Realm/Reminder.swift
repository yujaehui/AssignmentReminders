//
//  Reminder.swift
//  AssignmentReminders
//
//  Created by Jaehui Yu on 2/15/24.
//

import Foundation
import RealmSwift

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
