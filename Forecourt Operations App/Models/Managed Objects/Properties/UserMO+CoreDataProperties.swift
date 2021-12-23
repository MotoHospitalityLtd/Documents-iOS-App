//
//  UserMO+CoreDataProperties.swift
//  Forecourt Documents
//
//  Created by Edwards, Mike on 06/08/2021.
//
//

import Foundation
import CoreData


extension UserMO {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<UserMO> {
        return NSFetchRequest<UserMO>(entityName: "UserMO")
    }

    /// The local filePath for where the document is stored on the device.
    @NSManaged public var dateOfBirth: String?
    
    /// The local filePath for where the document is stored on the device.
    @NSManaged public var employeeNumber: String?
    
    /// The local filePath for where the document is stored on the device.
    @NSManaged public var authToken: String?

}

extension UserMO : Identifiable {

}
