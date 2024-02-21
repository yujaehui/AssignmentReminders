//
//  ReminderRepository.swift
//  AssignmentReminders
//
//  Created by Jaehui Yu on 2/16/24.
//

import Foundation
import RealmSwift

class ReminderRepository {
    let realm = try! Realm()
    
    func createItem(_ item: Reminder) {
        do {
            try realm.write {
                realm.add(item)
            }
        } catch {
            print(error)
        }
    }
    
    func fetchToday() -> Results<Reminder> {
        var calendar = Calendar.current
        calendar.locale = Locale(identifier: "ko_KR")
        calendar.timeZone = TimeZone(identifier: "Asia/Seoul")!
        let startOfDay = calendar.startOfDay(for: Date())
        let endOfDay = calendar.date(byAdding: .day, value: 1, to: startOfDay)!
        return realm.objects(Reminder.self).where{ $0.date >= startOfDay && $0.date <= endOfDay }
    }
    
    func fetchScheduled() -> Results<Reminder> {
        return realm.objects(Reminder.self).where{ $0.date > Date() }
    }
    
    func fetchAll() -> Results<Reminder> {
        return realm.objects(Reminder.self)
    }
    
    func fetchFlagged() -> Results<Reminder> {
        return realm.objects(Reminder.self).where{ $0.flag == true }
    }
    
    func fetchCompleted() -> Results<Reminder> {
        return realm.objects(Reminder.self).where{ $0.isCompleted == true }
    }
    
    func fetchSearch(text: String) -> Results<Reminder> {
        return realm.objects(Reminder.self).where { $0.title.contains(text, options: .caseInsensitive) }
    }
    
    func updateIsCompleted(id: ObjectId) {
        do {
            try realm.write {
                realm.objects(Reminder.self).where{ $0.id == id }.first?.isCompleted.toggle()
            }
        } catch {
            print(error)
        }
    }
    
    func updateFlag(id: ObjectId) {
        do {
            try realm.write {
                realm.objects(Reminder.self).where{$0.id == id}.first?.flag.toggle()
            }
        } catch {
            print(error)
        }
    }
    
    func deleteItem(list: Results<Reminder>, id: ObjectId) {
        do {
            try realm.write{
                realm.delete(list.where{ $0.id == id })
            }
        } catch {
            print(error)
        }
    }
}
