//
//  DirectoryMO+CoreDataProperties.swift
//  FCT Operations
//
//  Created by Edwards, Mike on 02/11/2021.
//
//

import Foundation
import CoreData


extension DirectoryMO {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<DirectoryMO> {
        return NSFetchRequest<DirectoryMO>(entityName: "DirectoryMO")
    }

    /// The unique directory id from the api.
    @NSManaged public var id: Int64
    
    /// The title of the directory.
    @NSManaged public var name: String?
    
    /// Used to keep track of the directory ordering.
    @NSManaged public var order: Int64
    
    /// The time the directory was last updated or modified.
    @NSManaged public var updatedAt: Double
    
    /// The child documents of this directory.
    @NSManaged public var documents: NSSet?
    
    /// The parent directory of this directory.
    @NSManaged public var parentDirectory: DirectoryMO?
    
    /// The child sub directories of this directory.
    @NSManaged public var subDirectories: NSSet?

}

// MARK: Generated accessors for documents
extension DirectoryMO {

    @objc(addDocumentsObject:)
    @NSManaged public func addToDocuments(_ value: DocumentMO)

    @objc(removeDocumentsObject:)
    @NSManaged public func removeFromDocuments(_ value: DocumentMO)

    @objc(addDocuments:)
    @NSManaged public func addToDocuments(_ values: NSSet)

    @objc(removeDocuments:)
    @NSManaged public func removeFromDocuments(_ values: NSSet)

}

// MARK: Generated accessors for subDirectories
extension DirectoryMO {

    @objc(addSubDirectoriesObject:)
    @NSManaged public func addToSubDirectories(_ value: DirectoryMO)

    @objc(removeSubDirectoriesObject:)
    @NSManaged public func removeFromSubDirectories(_ value: DirectoryMO)

    @objc(addSubDirectories:)
    @NSManaged public func addToSubDirectories(_ values: NSSet)

    @objc(removeSubDirectories:)
    @NSManaged public func removeFromSubDirectories(_ values: NSSet)

}

extension DirectoryMO : Identifiable {

}
