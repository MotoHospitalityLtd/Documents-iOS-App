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

    @NSManaged public var dateOfBirth: String?
    @NSManaged public var employeeNumber: String?
    @NSManaged public var expiry: Date?
    @NSManaged public var authToken: String?

}

extension UserMO : Identifiable {

}
