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
    @Persisted var folderName: String
    @Persisted var folderColor: Int
    @Persisted var regDate: Date
    @Persisted var reminder: List<Reminder>
    
    convenience init(folderName: String, folderColor: Int, regDate: Date) {
        self.init()
        self.folderName = folderName
        self.folderColor = folderColor
        self.regDate = regDate
    }
}
