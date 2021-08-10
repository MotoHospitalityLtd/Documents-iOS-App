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
        for document in jsonDocuments {
            
            let newDocument = DocumentMO(context: context)
            
            newDocument.id = document["id"] as! Int64
            newDocument.title = document["title"] as? String ?? "Untitled"
            newDocument.url = document["url"] as? String ?? "No URL"
            
//            newDocument.locationOnDisc

            
            documents.append(newDocument)
            
            print("File")
            print(document)
            print("------------")
        }
        
        return NSSet(array: documents)
    }
}
