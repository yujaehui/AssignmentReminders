//
//  Utility.swift
//  AssignmentReminders
//
//  Created by Jaehui Yu on 2/16/24.
//

import UIKit

class Utility {
    static let shared = Utility()
    private init() {}
    
    func dateFormatter(date: Date) -> String {
        let format = DateFormatter()
        format.dateFormat = "yyyy. MM. dd a h:mm"
        format.locale = Locale(identifier: "ko-KR")
        let result = format.string(from: date)
        return result
    }
}
