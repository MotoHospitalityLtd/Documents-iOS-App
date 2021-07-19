//
//  UserMO+CoreDataProperties.swift
//  Forecourt Documents
//
//  Created by Edwards, Mike on 16/07/2021.
//
//

import Foundation
import CoreData


extension UserMO {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<UserMO> {
        return NSFetchRequest<UserMO>(entityName: "UserMO")
    }

    @NSManaged public var token: String?
    @NSManaged public var username: String?
    @NSManaged public var password: String?

}

extension UserMO : Identifiable {

}
