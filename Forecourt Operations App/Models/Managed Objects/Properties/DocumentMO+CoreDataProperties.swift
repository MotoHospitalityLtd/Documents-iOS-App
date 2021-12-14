//
//  DocumentMO+CoreDataProperties.swift
//  FCT Operations
//
//  Created by Edwards, Mike on 08/11/2021.
//
//

import Foundation
import CoreData


extension DocumentMO {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<DocumentMO> {
        return NSFetchRequest<DocumentMO>(entityName: "DocumentMO")
    }

    @NSManaged public var filePath: String?
    @NSManaged public var id: Int64
    @NSManaged public var order: Int64
    @NSManaged public var title: String?
    @NSManaged public var updatedAt: Double
    @NSManaged public var url: String?
    @NSManaged public var isDownloaded: Bool
    @NSManaged public var directory: DirectoryMO?

}

extension DocumentMO : Identifiable {

}
