//
//  HostMO+CoreDataProperties.swift
//  Forecourt Documents
//
//  Created by Edwards, Mike on 21/07/2021.
//
//

import Foundation
import CoreData

extension HostMO {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<HostMO> {
        return NSFetchRequest<HostMO>(entityName: "HostMO")
    }

    @NSManaged public var name: String?
    @NSManaged public var url: String?

}

extension HostMO : Identifiable {

}
