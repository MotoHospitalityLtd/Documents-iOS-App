//
//  DocumentMO+CoreDataClass.swift
//  Forecourt Documents
//
//  Created by Edwards, Mike on 16/07/2021.
//
//

import Foundation
import CoreData

@objc(DocumentMO)
public class DocumentMO: NSManagedObject {
    static func createDocuments(fromJson jsonDocuments: [[String: AnyObject]], withContext context: NSManagedObjectContext) -> NSSet  {
        var documents: [DocumentMO] = []
        
        print("CREATE DOCUMENTS")
        var order: Int64 = 1
        for document in jsonDocuments {
            let newDocument = DocumentMO(context: context)
            
            newDocument.id = document["id"] as! Int64
            newDocument.order = order
            newDocument.title = document["title"] as? String ?? "Untitled"
            newDocument.url = document["url"] as? String ?? "No URL"
            newDocument.updatedAt = document["updated_at"] as! Double
            
            documents.append(newDocument)
            
            order += 1
//            print("File")
//            print(document)
//            print("------------")
        }
        
        return NSSet(array: documents)
    }
    
    static func createDocument(fromJson document: [String: AnyObject], withContext context: NSManagedObjectContext, order: Int64) -> DocumentMO  {
        print("CREATE SINGLE DOCUMENT")
        
        let newDocument = DocumentMO(context: context)
        
        newDocument.id = document["id"] as! Int64
        newDocument.order = order
        newDocument.title = document["title"] as? String ?? "Untitled"
        newDocument.url = document["url"] as? String ?? "No URL"
        newDocument.updatedAt = document["updated_at"] as! Double
        newDocument.isDownloaded = false
        
//            print("File")
//            print(document)
//            print("------------")
        
        return newDocument
    }
    
    static func fetchAllDocuments(withContext context: NSManagedObjectContext) -> [DocumentMO] {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "DocumentMO")
       
        do {
            return try context.fetch(request) as? [DocumentMO] ?? []
        }

        catch {
            fatalError("Error fetching all documents")
        }
    }
    
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
