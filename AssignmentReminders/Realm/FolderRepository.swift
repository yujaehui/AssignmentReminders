//
//  FolderRepository.swift
//  AssignmentReminders
//
//  Created by Jaehui Yu on 2/21/24.
//

import Foundation
import RealmSwift

class FolderRepository {
    let realm = try! Realm()
    
    func createFolder(_ folder: Folder) {
        do {
            try realm.write {
                realm.add(folder)
            }
        } catch {
            print(error)
        }
    }
    
    func createFolderInItem(_ folder: Folder, data: Reminder) {
        do {
            try realm.write {
                folder.reminder.append(data)
            }
        } catch {
            print(error)
        }
    }
    
    func fetchAllFolder() -> Results<Folder> {
        return realm.objects(Folder.self)
    }
    
    func deleteItem(list: Results<Folder>, id: ObjectId) {
        do {
            try realm.write{
                realm.delete(list.where{ $0.id == id }.first!.reminder) // 하위 항목 먼저 제거
                realm.delete(list.where{ $0.id == id })
            }
        } catch {
            print(error)
        }
    }
}
