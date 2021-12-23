//
//  DocumentMO+CoreDataClass.swift
//  Forecourt Documents
//
//  Created by Edwards, Mike on 16/07/2021.
//
//

import Foundation
import CoreData

/// This class holds a reference to a single document.
@objc(DocumentMO)
public class DocumentMO: NSManagedObject {
    
    /// Create a DocumentMO from the given json structure.
    /// - Parameters:
    ///   - jsonDocument: A json structure of a document.
    ///   - context: The core data managed object context.
    /// - Returns: An NSSet of DocumentMO objects.
   
    static func createDocument(fromJson jsonDocument: [String: AnyObject], withContext context: NSManagedObjectContext, order: Int64) -> DocumentMO  {
        print("Create a single document")
        
        let newDocument = DocumentMO(context: context)
        
        newDocument.id = jsonDocument["id"] as! Int64
        newDocument.order = order
        newDocument.title = jsonDocument["title"] as? String ?? "Untitled"
        newDocument.url = jsonDocument["url"] as? String ?? "No URL"
        newDocument.updatedAt = jsonDocument["updated_at"] as! Double
        newDocument.isDownloaded = false
        
        return newDocument
    }
    
    
    /// Fetch all existing documents.
    /// - Parameter context: The core data managed object context.
    /// - Returns: An array of DocumentMO's.
    static func fetchAllDocuments(withContext context: NSManagedObjectContext) -> [DocumentMO] {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "DocumentMO")
       
        do {
            return try context.fetch(request) as? [DocumentMO] ?? []
        }

        catch {
            fatalError("Error fetching all documents")
        }
    }
    
    /// Fetch a single DocumentMO with the given id.
    /// - Parameters:
    ///   - id: The id of the DocumentMO
    ///   - context: The core data managed object context.
    /// - Returns: A DocumentMO.
    static func fetchDocument(withId id: Int64, withContext context: NSManagedObjectContext) -> DocumentMO? {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "DocumentMO")
        let predicateId = NSPredicate(format: "id = %d", id)

        request.predicate = predicateId

        do {
            return try context.fetch(request).first as? DocumentMO
        }

        catch {
            fatalError("Error fetching document")
        }
    }
    
    /// Remove this documents file from disc.
    internal func removeFileOnDisc() {
        let fileManager = FileManager.default
        let docs = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first!

        let fileURL = docs.appendingPathComponent(filePath!)
        
        if fileManager.fileExists(atPath: fileURL.path) {
            do {
                try fileManager.removeItem(at: fileURL)
                print("File: \(fileURL.path) has been removed")
            }
            catch {
                print("File: \(fileURL.path) could not be removed")
            }
        }
        
        else {
            print("File does not exist")
        }
    }
}
