//
//  DirectoryMO+CoreDataClass.swift
//  Forecourt Documents
//
//  Created by Edwards, Mike on 16/07/2021.
//
//

import Foundation
import CoreData

/// This class holds a reference to a single directory.
@objc(DirectoryMO)
public class DirectoryMO: NSManagedObject {
    
    /// Return the child documents and directories.
    var visibleItems: [Any] {
        get {
            let subDirectories = (subDirectories?.allObjects as? [DirectoryMO] ?? []).sorted {$0.order < $1.order}
            let documents = (documents?.allObjects as? [DocumentMO] ?? []).sorted {$0.order < $1.order}

            return subDirectories + documents
        }
    }
    
    /// Configure a DirectoryMO
    /// - Parameters:
    ///   - jsonDirectory: A json structure of a directory
    ///   - order: The order of the directory
    internal func configure(jsonDirectory: [String: AnyObject], order: Int64) {
        self.id = jsonDirectory["id"] as! Int64
        self.order = order
        self.name = jsonDirectory["title"] as? String ?? "Untitled"
        self.updatedAt = jsonDirectory["updated_at"] as! Double
    }
    
    /// Fetch all existing directories, apart from the root level directory with an id of 0.
    /// - Parameter context: The core data managed object context from which to retrieve the directories.
    /// - Returns: An array of DirectoryMO's.
    static func fetchAllDirectories(withContext context: NSManagedObjectContext) -> [DirectoryMO] {
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "DirectoryMO")
        let predicateId = NSPredicate(format: "id != %d", 0)
        
        request.predicate = predicateId
       
        do {
            return try context.fetch(request) as? [DirectoryMO] ?? []
        }

        catch {
            fatalError("Error fetching all directories")
        }
    }
}
