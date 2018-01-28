//
//  DateTime.swift
//  clockIn
//
//  Created by NewfieRocket on 2018-01-22.
//  Copyright © 2018 NewfieRocket. All rights reserved.
//

import Foundation

class DateTime {
    var currentDateTime = Date()
    var formatter = DateFormatter()
    
    func currentDate() -> String {
        formatter.timeStyle = .medium
        formatter.dateStyle = .medium
        return formatter.string(from: currentDateTime)
    }
    func currentTime() -> String {
        formatter.dateStyle = .none
        formatter.timeStyle = .short
        return formatter.string(from: currentDateTime)
    }
    
}

