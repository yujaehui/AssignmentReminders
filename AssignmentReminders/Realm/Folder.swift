//
//  Folder.swift
//  AssignmentReminders
//
//  Created by Jaehui Yu on 2/20/24.
//

import Foundation
import RealmSwift

class Folder: Object {
    @Persisted(primaryKey: true) var id: ObjectId
    @Persisted var isFood: Bool
    @Persisted var name: String
    @Persisted var color: Int
    @Persisted var regDate: Date
    @Persisted var reminder: List<Reminder>
    
    convenience init(folderName: String, folderColor: Int, regDate: Date) {
        self.init()
        self.isFood = false
        self.name = folderName
        self.color = folderColor
        self.regDate = regDate
    }
}
