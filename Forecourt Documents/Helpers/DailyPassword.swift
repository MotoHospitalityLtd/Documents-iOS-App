//
//  DailyPassword.swift
//  Forecourt Documents
//
//  Created by Edwards, Mike on 04/08/2021.
//

import Foundation

class DailyPassword {
    static func forToday() -> String {
        return generatePassword(fromDate: Date())
    }
    
    static func forDate(date: Date) -> String {
        return generatePassword(fromDate: date)
    }
    
    private static func generatePassword(fromDate date: Date) -> String {
        // Get the seconds since the epoch from a given date.
        let timeInterval = date.timeIntervalSince1970
        
        // Round the seconds to the nearest day.
        let currentDay = Int(floor(timeInterval / 86400))
        
        // Get an MD5 data hash of the currentDay.
        let md5Data = Hash.md5(string: String(currentDay))
        
        // Convert the hash to hex string.
        let md5Hex = md5Data.map { String(format: "%02hhx", $0) }.joined()
        
        // Create a 6 character password from the hex string starting using the dayOfWeek as the starting index.
        return md5Hex.subString(fromIndex: date.dayOfWeek, advanceBy: 6)
    }
    
    static func authenticate(password: String, forDate date: Date = Date()) -> Bool {
        // Check a given password matches the generated daily password.
        return password == generatePassword(fromDate: date) ? true : false
    }
}
