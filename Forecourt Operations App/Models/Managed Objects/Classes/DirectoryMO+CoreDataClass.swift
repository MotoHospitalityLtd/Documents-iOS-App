//
//  DirectoryMO+CoreDataClass.swift
//  Forecourt Documents
//
//  Created by Edwards, Mike on 16/07/2021.
//
//

import Foundation
import CoreData

@objc(DirectoryMO)
public class DirectoryMO: NSManagedObject {
    
    var visibleItems: [Any] {
        get {
            let subDirectories = (subDirectories?.allObjects as? [DirectoryMO] ?? []).sorted {$0.order < $1.order}
            let documents = (documents?.allObjects as? [DocumentMO] ?? []).sorted {$0.order < $1.order}

            return subDirectories + documents
        }
    }
    
    internal func configure(jsonDirectory: [String: AnyObject], order: Int64) {
        self.id = jsonDirectory["id"] as! Int64
        self.order = order
        self.name = jsonDirectory["title"] as? String ?? "Untitled"
        self.updatedAt = jsonDirectory["updated_at"] as! Double
    }

    private func removeDirectories(withContext context: NSManagedObjectContext, directoryIds: [Int64]) {
        for directoryId in directoryIds {
            print("Directory: \(directoryId) has been removed")
            let directory = DirectoryMO.fetchDirectory(withId: directoryId, withContext: context)
            context.delete(directory)
        }
    }

    static func fetchAllDirectories(withContext context: NSManagedObjectContext) -> [DirectoryMO] {
        // Fetch all directories apart from the root level directory with an id of 0.
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
    
    static func fetchDirectory(withId id: Int64, withContext context: NSManagedObjectContext) -> DirectoryMO {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "DirectoryMO")
        let predicateId = NSPredicate(format: "id = %d", id)

        request.predicate = predicateId

        do {
            return try context.fetch(request).first as! DirectoryMO
        }

        catch {
            fatalError("Error fetching directory")
        }
    }
}
