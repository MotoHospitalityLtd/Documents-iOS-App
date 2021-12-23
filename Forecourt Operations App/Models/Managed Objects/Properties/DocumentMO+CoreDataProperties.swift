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
    
    /// The local filePath for where the document is stored on the device.
    @NSManaged public var filePath: String?
    
    /// The unique document id from the api.
    @NSManaged public var id: Int64
    
    /// Used to keep track of the document ordering.
    @NSManaged public var order: Int64
    
    /// The title of the document.
    @NSManaged public var title: String?
    
    /// The time the document was last updated or modified.
    @NSManaged public var updatedAt: Double
    
    /// The S3 URL where the document can be downloaded from.
    @NSManaged public var url: String?
    
    /// Used to keep track on whether the latest version of this document has been downloaded.
    @NSManaged public var isDownloaded: Bool
    
    /// The parent directory of the document.
    @NSManaged public var directory: DirectoryMO?

}

extension DocumentMO : Identifiable {

}
