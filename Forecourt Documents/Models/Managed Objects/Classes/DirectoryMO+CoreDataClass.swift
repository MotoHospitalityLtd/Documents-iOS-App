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
            let subDirectories = subDirectories?.allObjects as? [DirectoryMO] ?? []
            let documents = documents?.allObjects as? [DocumentMO] ?? []
            
            return subDirectories + documents
        }
    }
    
//    var visibleItems: [Any] = []

//    private func setVisibleItems() {
//        let subDirectories = subDirectories?.allObjects as? [DirectoryMO]
//        let documents = documents?.allObjects as? [DocumentMO]
//
//        visibleItems = subDirectories! + documents!
//    }
    
    static func createRootDirectory(fromJSon jsonDirectories: [[String: AnyObject]], withContext context: NSManagedObjectContext) -> DirectoryMO {
    
        var rootDirectories: [DirectoryMO] = []
        
        var order: Int64 = 1
        
        for jsonDirectory in jsonDirectories {
            
            
//            print("JsonDirectory")
//            print(jsonDirectory)
            
            let rootDirectory = createDirectory(fromJson: jsonDirectory, withContext: context)
            rootDirectories.append(rootDirectory)
            
    
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
       
        
    
        
//        print("Root Directory Count")
//        print(rootDirectories.count)
        
        // Create a diretory
        // if directory has subDirectories, create them.
        
        
    }
    
    
    static private func createDirectory(fromJson jsonDirectory: [String: AnyObject], withContext context: NSManagedObjectContext) -> DirectoryMO {
        let newDirectory = DirectoryMO(context: context)
    
        newDirectory.id = jsonDirectory["id"] as! Int64
        newDirectory.name = jsonDirectory["title"] as? String ?? "Untitled"
        
        if let jsonDocuments = jsonDirectory["files"] as? [[String: AnyObject]] {
            
            newDirectory.addToDocuments(DocumentMO.createDocuments(fromJson: jsonDocuments, withContext: context))
//            let docs = createDocuments(fromJson: jsonDocuments)
            
            print("DOC COUNT")
            print(newDirectory.documents!.count)
            
        }
        
        if let jsonSubDirectories = jsonDirectory["children"] as? [[String: AnyObject]] {
            var subDirectories: [DirectoryMO] = []
            
            print("SubDirectory Count")
            print(subDirectories.count)
            
            for jsonSubDirectory in jsonSubDirectories {
//                print("JSON SUB")
//                print(jsonSubDirectory)
                let subDirectory = createDirectory(fromJson: jsonSubDirectory, withContext: context)
                subDirectories.append(subDirectory)
            }
            
            newDirectory.addToSubDirectories(NSSet(array: subDirectories))
        }
        
//        newDirectory.subDirectories = subDirectories
        
        return newDirectory
    }
}
