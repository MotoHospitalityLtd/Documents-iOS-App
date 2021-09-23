//
//  Date+Extension.swift
//  Forecourt Documents
//
//  Created by Edwards, Mike on 04/08/2021.
//

import Foundation

extension Date {
    
    // Return the dates weekday number from 1 - 7 with 1 being Monday.
    var dayOfWeek: Int {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.weekday], from: self)
        return components.weekday!
    }
    
}
