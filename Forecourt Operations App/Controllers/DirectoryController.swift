//
//  DirectoryController.swift
//  Forecourt Documents
//
//  Created by Edwards, Mike on 09/08/2021.
//

import Foundation
import CoreData

class DirectoryController {
    
    //# MARK: - Data
    let coreData: CoreData
    
    //# MARK: - Variables
    var directoryPath: [Int] = []
    
    var existingDirectories: [DirectoryMO] = []
    var existingDocuments: [DocumentMO] = []
    
    var rootDirectory: DirectoryMO?
    var currentDirectory: DirectoryMO?
    
    //# MARK: - Controllers:
    let networkController: NetworkController
    let documentController: DocumentController
    
    //# MARK: - Initialisers
    init(coreData: CoreData, networkController: NetworkController, documentController: DocumentController) {
        self.coreData = coreData
        self.networkController = networkController
        self.documentController = documentController
        
        rootDirectory = fetchRootDirectory()
        currentDirectory = rootDirectory
    }
    
    internal func downloadDirectories(completion: @escaping (NetworkController.NetworkResponse) -> Void) {
        self.networkController.get(urlPath: "/api/root-directory") { response in
            DispatchQueue.main.async {
                switch response {
                case .success(let data):
                    print("Success")
                    
                    do {
                        let decodedData = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as! [String: AnyObject]
                        
                        let directoryData = decodedData["data"] as! [[String: AnyObject]]
                        
                        self.createFileStructure(fromJson: directoryData)
                        
                        self.currentDirectory = self.rootDirectory
   
                        self.coreData.save(context: self.coreData.persistentContainer.viewContext)

                        completion(.success(nil))
                    }
                        
                    catch {
                        print("catch error: \(error)")
                    }
                    
                case .error(let httpError):
                   completion(.error(httpError))
                }
            }
        }
    }
    
    internal func clearData() {
        removeAllDirectories()
        
        documentController.removeAllDocuments()
        self.coreData.save(context: self.coreData.persistentContainer.viewContext)
    }
    
    internal func removeAllDirectories() {
        for directory in DirectoryMO.fetchAllDirectories(withContext: coreData.persistentContainer.viewContext) {
            print("Removed directory")
            coreData.persistentContainer.viewContext.delete(directory)
        }
        
        directoryPath = []
    }
    
    private func loadRootDirectory() -> DirectoryMO? {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "DirectoryMO")

        // The id for the root directory is 0
        let predicateId = NSPredicate(format: "id = %d", 0)

        request.predicate = predicateId

        do {
            return try coreData.persistentContainer.viewContext.fetch(request).first as? DirectoryMO
        }

        catch {
            fatalError("Error fetching user")
        }
    }
    
    internal func setCurrentDirectory() {
        // Array of tapped indexes from visible items (can only be directory)
        // [0, 0, 1]
        print("DirectoryPath Before: \(directoryPath)")
        
        directoryPath.removeLast(1)
        
        print("DirectoryPath After: \(directoryPath)")
        
        var position = rootDirectory!
        
        for index in directoryPath {
            position = getSubDirectory(ofDirectory: position, withIndex: index)
        }
        
        currentDirectory = position
    }
    
    internal func getSubDirectory(ofDirectory directory: DirectoryMO, withIndex index: Int) -> DirectoryMO {
        return directory.visibleItems[index] as! DirectoryMO
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
    func createFileStructure(fromJson jsonDirectories: [[String: AnyObject]]) {
        var topLevelDirectories: [DirectoryMO] = []
        
        var order: Int64 = 1
        
        existingDirectories = DirectoryMO.fetchAllDirectories(withContext: coreData.persistentContainer.viewContext)
        existingDocuments = DocumentMO.fetchAllDocuments(withContext: coreData.persistentContainer.viewContext)
        
        print("Existing Directory Count: \(existingDirectories.count)")
        print("Existing Document count: \(existingDocuments.count)")
        
        // 1st level directories
        for jsonDirectory in jsonDirectories {
    
            let topLevelDirectory = setupDirectory(fromJson: jsonDirectory, order: order)
            
            let directoryToRemove: Set<DirectoryMO> = [topLevelDirectory]
            existingDirectories.removeAll(where: {directoryToRemove.contains($0)})
        
            topLevelDirectories.append(topLevelDirectory)
            
            rootDirectory!.subDirectories = NSSet(array: topLevelDirectories)
            
            order += 1
        }
        
        print("Document count before delete: \(existingDocuments.count)")
        print("Directory Count before delete: \(existingDirectories.count)")
        print("1st Level Directories: \(topLevelDirectories.count)")
        
        removeDirectories()
        removeDocuments()
        
        print("Document count after delete: \(existingDocuments.count)")
        print("Directory Count after delete: \(existingDirectories.count)")
    }
    
    func setupDirectory(fromJson jsonDirectory: [String: AnyObject], order: Int64) -> DirectoryMO {
        // Setup Directory
        print("Setup Directory")
        
        var directoryToSetup: DirectoryMO
        
        if let existingDirectory = fetchDirectory(withId: jsonDirectory["id"] as! Int64) {
        
            directoryToSetup = existingDirectory
            // EXISTING DIRECTORY
            print("EXISTING DIRECTORY SETUP")
            
            // Directory still exists so remove its id from the list to prevent it getting deleted.
            print("Existing Directories Before")
            print("Existing Directories Count Before: \(existingDirectories.count)")
            
            let directoryToRemove: Set<DirectoryMO> = [existingDirectory]
            existingDirectories.removeAll(where: {directoryToRemove.contains($0)})
            
            print("Existing Directories After")
            print("Existing Directories Count After: \(existingDirectories.count)")
            
            let updatedAt = jsonDirectory["updated_at"] as! Double
            
            if directoryToSetup.updatedAt == updatedAt {
                // Directory already up to date
                print("Directory already up to date")
            }
            
            else {
                // Directory info has changed
                print("Directory info has changed - UPDATE")
                
                directoryToSetup.configure(jsonDirectory: jsonDirectory, order: order)
            }
        }

        else {
            // NEW DIRECTORY
            print("NEW DIRECTORY SETUP")
            
            directoryToSetup = DirectoryMO(context: coreData.persistentContainer.viewContext)
            directoryToSetup.configure(jsonDirectory: jsonDirectory, order: order)
        }
        
        if let jsonDocuments = jsonDirectory["files"] as? [[String: AnyObject]] {
            print("Inside JSON Documents")

            directoryToSetup.documents = documentHelper(jsonDocuments: jsonDocuments)
        }

        if let jsonSubDirectories = jsonDirectory["children"] as? [[String: AnyObject]] {
            var subDirectories: [DirectoryMO] = []
            
            var order: Int64 = 1
            
            for jsonSubDirectory in jsonSubDirectories {
                let subDirectory = setupDirectory(fromJson: jsonSubDirectory, order: order)
                subDirectories.append(subDirectory)
                
                order += 1
            }
            
            print("SubDirectory Count")
            print(subDirectories.count)
            
            directoryToSetup.subDirectories = NSSet(array: subDirectories)
        }
        
        return directoryToSetup
    }
    
    func documentHelper(jsonDocuments: [[String: AnyObject]]) -> NSSet {
        print("DOCUMENT HELPER")
        var documents: [DocumentMO] = []
        
        var order: Int64 = 1
        
        for jsonDocument in jsonDocuments {
            let documentId = jsonDocument["id"] as! Int64
            
            if let existingDocument = DocumentMO.fetchDocument(withId: documentId, withContext: coreData.persistentContainer.viewContext) {
                
                // Document still exists so remove its id from the list to prevent it getting deleted.
                let documentToRemove: Set<DocumentMO> = [existingDocument]
                existingDocuments.removeAll(where: {documentToRemove.contains($0)})
                
                let updatedAt = jsonDocument["updated_at"] as! Double
                
                if existingDocument.updatedAt == updatedAt {
                    // Document up to date. No change required
                    print("Existing Document With Id: \(documentId) already up to date")
                    existingDocument.isDownloaded = true
                }
                
                else {
                    // Update Document
                    print("Existing Document With Id: \(documentId) has been updated - UPDATE")
                    existingDocument.id = jsonDocument["id"] as! Int64
                    existingDocument.order = order
                    existingDocument.title = jsonDocument["title"] as? String ?? "Untitled"
                    
                    let newDocumentURL = jsonDocument["url"] as? String ?? "No URL"
                    
                    existingDocument.updatedAt = jsonDocument["updated_at"] as! Double
                    
                    print("New Document URL: \(newDocumentURL)")
                    print("Existing Document URL: \(existingDocument.url)")
                    
                    // URL CHANGES IF THE NAME CHANGES - WORKING HERE
                    if newDocumentURL != existingDocument.url {
                        print("URLS DIFFERENT")
                        
                        existingDocument.removeFileOnDisc()
                        
                        existingDocument.url = jsonDocument["url"] as? String ?? "No URL"
                        existingDocument.isDownloaded = false
                    }
                }
                
                documents.append(existingDocument)
            }
            
            else {
                print("Non Existing Document - Create New")
                
                let newDocument = DocumentMO(context: coreData.persistentContainer.viewContext)
                
                newDocument.id = jsonDocument["id"] as! Int64
                newDocument.order = order
                newDocument.title = jsonDocument["title"] as? String ?? "Untitled"
                newDocument.url = jsonDocument["url"] as? String ?? "No URL"
                newDocument.updatedAt = jsonDocument["updated_at"] as! Double
                newDocument.isDownloaded = false
                
                documents.append(newDocument)
            }
            
            order += 1
        }
        
        return NSSet(array: documents)
    }
    
    func fetchDirectory(withId id: Int64) -> DirectoryMO? {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "DirectoryMO")
        let predicateId = NSPredicate(format: "id = %d", id)

        request.predicate = predicateId

        do {
            return try coreData.persistentContainer.viewContext.fetch(request).first as? DirectoryMO
        }

        catch {
            fatalError("Error fetching directory")
        }
    }
    
    private func fetchRootDirectory() -> DirectoryMO {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "DirectoryMO")
        let predicateId = NSPredicate(format: "name = %@", "Root Directory")

        request.predicate = predicateId

        do {
            let rootDirectory = try coreData.persistentContainer.viewContext.fetch(request).first as? DirectoryMO
            
            if rootDirectory == nil {
                print("NO ROOT LEVEL DIRECTORY")
                return createRootDirectory()
            }
            
            else {
                print("ROOT LEVEL EXISTS ALREADY")
                return rootDirectory!
            }
        }

        catch {
            fatalError("Error fetching directory")
        }
    }
    
    private func createRootDirectory() -> DirectoryMO {
        let newRootDirectory = DirectoryMO(context: coreData.persistentContainer.viewContext)
        newRootDirectory.id = 0
        newRootDirectory.order = 0
        newRootDirectory.name = "Root Directory"
        
        return newRootDirectory
    }
    
    private func removeDirectories() {
        for directory in existingDirectories {
            print("Directory: \(directory.name!) has been removed")
            coreData.persistentContainer.viewContext.delete(directory)
        }
        
        existingDirectories = []
    }
    
    private func removeDocuments() {
        for document in existingDocuments {
            print("Document: \(document.title!) has been removed")
            // Delete downloaded file
    
            print("filePath: \(document.filePath)")
            print("url: \(document.url)")
                
            document.removeFileOnDisc()
            coreData.persistentContainer.viewContext.delete(document)
        }

        existingDirectories = []
    }
}
