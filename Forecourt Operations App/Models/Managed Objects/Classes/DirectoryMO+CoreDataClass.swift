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
    
    
    
    // User logs in
    // Create array of ids of local directories and documents
    
    // Download directories
    // LOOP through json directories and compare with local stored ones
        // Local directory id exists
            // Yes
                // Remove ID from array.
                // Updated time the same?
                    // Yes
                        // Do nothing
                    // No
                        // Update directory details.
            // No
                // Create directory
    // Loop through remaining array directory ids and delete them as they no longer exist.
   
    
    // Documents to re-download array?
    // Download documents
    // Loop through json documents and compare with local stored ones
        // Local document id exists
            // Yes
                // Remove ID from array.
                // Update time the same?
                    // Yes
                        // Do nothing
                    // No
                        // Add id to re-download array and update any details.. url, ect.
            // No
                // Create document
    // Loop through remaining array directory ids and delete them as they no longer exist.
    
    
    static func createRootDirectory(fromJSon jsonDirectories: [[String: AnyObject]], withContext context: NSManagedObjectContext) -> DirectoryMO {
        var rootDirectories: [DirectoryMO] = []
        
        var order: Int64 = 1
        
        for jsonDirectory in jsonDirectories {
            
//            print("JsonDirectory")
//            print(jsonDirectory)
            
            let rootDirectory = createDirectory(fromJson: jsonDirectory, withContext: context, order: order)
            rootDirectories.append(rootDirectory)
            
            order += 1
//            print("Directory")
//            print(jsonDirectory)
//            print("---------------")
        }
        
        let newRootDirectory = DirectoryMO(context: context)
        newRootDirectory.id = 0
        newRootDirectory.order = 0
        newRootDirectory.name = "Root Directory"
        newRootDirectory.addToSubDirectories(NSSet(array: rootDirectories))
        
        print("Root Directories")
        print(rootDirectories.count)
        
        return newRootDirectory
    }
    
    static private func createDirectory(fromJson jsonDirectory: [String: AnyObject], withContext context: NSManagedObjectContext, order: Int64) -> DirectoryMO {
        let newDirectory = DirectoryMO(context: context)
    
        newDirectory.id = jsonDirectory["id"] as! Int64
        newDirectory.order = order
        newDirectory.name = jsonDirectory["title"] as? String ?? "Untitled"
        
        if let jsonDocuments = jsonDirectory["files"] as? [[String: AnyObject]] {
            
            newDirectory.addToDocuments(DocumentMO.createDocuments(fromJson: jsonDocuments, withContext: context))
            
            print("DOC COUNT")
            print(newDirectory.documents!.count)
            
        }
        
        if let jsonSubDirectories = jsonDirectory["children"] as? [[String: AnyObject]] {
            var subDirectories: [DirectoryMO] = []
            
            print("SubDirectory Count")
            print(subDirectories.count)
            
            var order: Int64 = 1
            
            for jsonSubDirectory in jsonSubDirectories {
                let subDirectory = createDirectory(fromJson: jsonSubDirectory, withContext: context, order: order)
                subDirectories.append(subDirectory)
                
                order += 1
            }
            
            newDirectory.addToSubDirectories(NSSet(array: subDirectories))
        }
        
        return newDirectory
    }
}
