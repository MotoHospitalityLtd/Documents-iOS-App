//
//  DirectoryMO+CoreDataProperties.swift
//  Forecourt Documents
//
//  Created by Edwards, Mike on 13/08/2021.
//
//

import Foundation
import CoreData


extension DirectoryMO {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<DirectoryMO> {
        return NSFetchRequest<DirectoryMO>(entityName: "DirectoryMO")
    }

    @NSManaged public var id: Int64
    @NSManaged public var name: String?
    @NSManaged public var order: Int64
    @NSManaged public var documents: NSSet?
    @NSManaged public var parentDirectory: DirectoryMO?
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
