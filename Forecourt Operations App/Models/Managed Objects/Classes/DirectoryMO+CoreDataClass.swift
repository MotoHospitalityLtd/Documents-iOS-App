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
    
    // User logs in
    // Create array of ids of local directories and documents
    
    // Download directories
    // LOOP through json directories and compare with local stored ones
        // Local directory id exists
            // Yes
                // Remove Id from array.
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
    
    
    
    // Delete documents that need to be updated or that no longer exist.
    
//    static func createRootDirectory(fromJSon jsonDirectories: [[String: AnyObject]], withContext context: NSManagedObjectContext) -> DirectoryMO {
//        var rootDirectories: [DirectoryMO] = []
//
//        var order: Int64 = 1
//
//        for jsonDirectory in jsonDirectories {
//
////            print("JsonDirectory")
////            print(jsonDirectory)
//
//            let rootDirectory = createDirectory(fromJson: jsonDirectory, withContext: context, order: order)
//            rootDirectories.append(rootDirectory)
//
//            order += 1
////            print("Directory")
////            print(jsonDirectory)
////            print("---------------")
//        }
//
//        let newRootDirectory = DirectoryMO(context: context)
//        newRootDirectory.id = 0
//        newRootDirectory.order = 0
//        newRootDirectory.name = "Root Directory"
//        newRootDirectory.addToSubDirectories(NSSet(array: rootDirectories))
//
//        print("Root Directories")
//        print(rootDirectories.count)
//
//
//        // Remove documents
//
//        return newRootDirectory
//    }
 
    
//    static private func createDirectory(fromJson jsonDirectory: [String: AnyObject], withContext context: NSManagedObjectContext, order: Int64) -> DirectoryMO {
//        var existingDirectoryIds: [Int64] = []
//        var existingDocumentIds: [Int64] = []
//
//        // Collect all the id's of any existing directories.
//        for directory in DirectoryMO.fetchAllDirectories(withContext: context) {
//            existingDirectoryIds.append(directory.id)
//        }
//
//        // Collect all the id's of any existing documents.
//        for document in DocumentMO.fetchAllDocuments(withContext: context) {
//            existingDocumentIds.append(document.id)
//        }
//
//        for document in DocumentMO.fetchAllDocuments(withContext: context) {
//            print("ABOUT TO REMOVE DOCUMENT TEST")
//            document.removeFileOnDisc()
//        }
//
////        // Loop through the json directories
////        for jsonDirectory in jsonDirectories {
//
////            print("JsonDirectory")
////            print(jsonDirectory)
//
//        // Get the id of the current directory.
//        let directoryId = jsonDirectory["id"] as! Int64
//
//        // Check if the json directory already exists locally.
//        if existingDirectoryIds.contains(directoryId) {
//
//            // Fetch the existing directory.
//            let existingDirectory = DirectoryMO.fetchDirectory(withId: directoryId, withContext: context)
//
//            // Get the json time the directory was updated.
//            let updatedAt = jsonDirectory["updated_at"] as! Double
//
//            // Check if the json updated time matches the locally stored updated time.
//            if existingDirectory.updatedAt == updatedAt {
//                print("No Changes Needed")
//                // No changes needed.
//            }
//
//            else {
//                // Update directory.
//                print("UPDATE DIRECTORY")
//                existingDirectory.order = order
//                existingDirectory.name = jsonDirectory["title"] as? String ?? "Untitled"
//                existingDirectory.updatedAt = jsonDirectory["updated_at"] as! Double
//
//                let idToRemove: Set<Int64> = [directoryId]
//
//                existingDirectoryIds.removeAll(where: {idToRemove.contains($0)})
//            }
//
//            // DOCUMENT MANAGEMENT
//
//            // If its an existing directory... loop through and update the documents
//            if let jsonDocuments = jsonDirectory["files"] as? [[String: AnyObject]] {
//                // UPDATE DOCUMENT
//
//                var order: Int64 = 1
//
//                for jsonDocument in jsonDocuments {
//
//                    // Get the id of the current document.
//                    let documentId = jsonDocument["id"] as! Int64
//
////                    if existingDocumentIds.contains(documentId) {
////                        // UPDATE DOCUMENT
////
////                        // Fetch the existing document.
////                        let existingDocument = DocumentMO.fetchDocument(withId: documentId, withContext: context)
////
////                        existingDocument.id = jsonDocument["id"] as! Int64
////                        existingDocument.order = order
////                        existingDocument.title = jsonDocument["title"] as? String ?? "Untitled"
////                        existingDocument.url = jsonDocument["url"] as? String ?? "No URL"
////                        existingDocument.updatedAt = jsonDocument["updated_at"] as! Double
////
////                        let idToRemove: Set<Int64> = [documentId]
////
////                        existingDocumentIds.removeAll(where: {idToRemove.contains($0)})
////                    }
////
////                    else {
////                        // NEW DOCUMENT
////                        existingDirectory.addToDocuments(DocumentMO.createDocument(fromJson: jsonDocument, withContext: context, order: order))
////                    }
//
//                    order += 1
//                }
//
////                addToDocuments(DocumentMO.createDocuments(fromJson: jsonDocuments, withContext: context))
//
//                print("DOC COUNT")
//                print(existingDirectory.documents!.count)
//            }
//
////            if let jsonSubDirectories = jsonDirectory["children"] as? [[String: AnyObject]] {
////                var subDirectories: [DirectoryMO] = []
////
////                print("SubDirectory Count")
////                print(subDirectories.count)
////
////                var order: Int64 = 1
////
////                for jsonSubDirectory in jsonSubDirectories {
////                    let exi = createDirectory(fromJson: jsonSubDirectory, withContext: context, order: order)
////                    order += 1
////                }
////            }
//
//            return existingDirectory
//        }
//
//        else {
//            // Directory doesn't exist - create.
//            print("CREATE NEW DIRECTORY")
//            let newDirectory = DirectoryMO(context: context)
//
//            newDirectory.id = jsonDirectory["id"] as! Int64
//            newDirectory.order = order
//            newDirectory.name = jsonDirectory["title"] as? String ?? "Untitled"
//            newDirectory.updatedAt = jsonDirectory["updated_at"] as! Double
//
//            if let jsonDocuments = jsonDirectory["files"] as? [[String: AnyObject]] {
//                // UPDATE DOCUMENT
//
//                var order: Int64 = 1
//
//                for jsonDocument in jsonDocuments {
//
//                    // Get the id of the current document.
//                    let documentId = jsonDocument["id"] as! Int64
//
//                    if existingDocumentIds.contains(documentId) {
//                        // Fetch the existing document.
//                        let existingDocument = DocumentMO.fetchDocument(withId: documentId, withContext: context)
//
//                        // Get the json time the document was updated.
//                        let updatedAt = jsonDocument["updated_at"] as! Double
//
////                        if existingDocument.updatedAt == updatedAt {
////                            // Document up to date. No change required
////                            existingDocument.isDownloaded = true
////                        }
////
////                        else {
////                            // UPDATE DOCUMENT
////                            existingDocument.id = jsonDocument["id"] as! Int64
////                            existingDocument.order = order
////                            existingDocument.title = jsonDocument["title"] as? String ?? "Untitled"
////                            existingDocument.url = jsonDocument["url"] as? String ?? "No URL"
////                            existingDocument.updatedAt = jsonDocument["updated_at"] as! Double
////                            existingDocument.isDownloaded = false
////
////                            let idToRemove: Set<Int64> = [documentId]
////
////                            existingDocumentIds.removeAll(where: {idToRemove.contains($0)})
////                        }
//                    }
//
//                    else {
//                        // NEW DOCUMENT
//                        newDirectory.addToDocuments(DocumentMO.createDocument(fromJson: jsonDocument, withContext: context, order: order))
//                    }
//                }
//
//                order += 1
//            }
//
////            if let jsonDocuments = jsonDirectory["files"] as? [[String: AnyObject]] {
////                newDirectory.addToDocuments(DocumentMO.createDocuments(fromJson: jsonDocuments, withContext: context))
////
////                print("DOC COUNT")
////                print(newDirectory.documents!.count)
////            }
//
//            if let jsonSubDirectories = jsonDirectory["children"] as? [[String: AnyObject]] {
//                var subDirectories: [DirectoryMO] = []
//
//                print("SubDirectory Count")
//                print(subDirectories.count)
//
//                var order: Int64 = 1
//
//                for jsonSubDirectory in jsonSubDirectories {
//                    let subDirectory = createDirectory(fromJson: jsonSubDirectory, withContext: context, order: order)
//                    subDirectories.append(subDirectory)
//
//                    order += 1
//                }
//
//                newDirectory.addToSubDirectories(NSSet(array: subDirectories))
//            }
//
//            return newDirectory
//        }
//    }
    
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
