//
//  DocumentMO+CoreDataProperties.swift
//  Forecourt Documents
//
//  Created by Edwards, Mike on 16/07/2021.
//
//

import Foundation
import CoreData


extension DocumentMO {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<DocumentMO> {
        return NSFetchRequest<DocumentMO>(entityName: "DocumentMO")
    }

    @NSManaged public var id: Int64
    @NSManaged public var title: String?
    @NSManaged public var url: String?
    @NSManaged public var directory: DirectoryMO?

}

extension DocumentMO : Identifiable {

}
