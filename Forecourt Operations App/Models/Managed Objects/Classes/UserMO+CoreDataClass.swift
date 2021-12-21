//
//  UserMO+CoreDataClass.swift
//  Forecourt Documents
//
//  Created by Edwards, Mike on 16/07/2021.
//
//

import Foundation
import CoreData

@objc(UserMO)
public class UserMO: NSManagedObject {
    
    internal func setLoginExpiry() {
        // Set the expiry to be 1 hour ahead from the current system date. This could be expanded so you can choose a time frame.
        expiry = Date().addingTimeInterval(3600)
    }
    
}
