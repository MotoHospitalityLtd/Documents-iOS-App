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
    
    var rootDirectory: DirectoryMO?
    var currentDirectory: DirectoryMO?
    
    //# MARK: - Controllers:
    let networkController: NetworkController
    
    //# MARK: - Initialisers
    init(coreData: CoreData, networkController: NetworkController) {
        self.coreData = coreData
        self.networkController = networkController
        
        rootDirectory = loadRootDirectory()
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
                        
//                        self.createDirectories(fromJson: directoryData)
                        
                        
                        self.rootDirectory = DirectoryMO.createRootDirectory(fromJSon: directoryData, withContext: self.coreData.persistentContainer.viewContext)
                        self.currentDirectory = self.rootDirectory
                        
                        print("AFTER ADDING")
//                        dump(self.rootDirectory)
                        
                        self.coreData.save(context: self.coreData.persistentContainer.viewContext)
                        
//                        print("DATA")
//                        print(directoryData)
                        
                        
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
    
    internal func removeAllDirectories() {
        for directory in fetchAllDirectories() {
            print("Removed directory")
            coreData.persistentContainer.viewContext.delete(directory)
        }
    }
    
    private func fetchAllDirectories() -> [DirectoryMO] {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "DirectoryMO")

        do {
            return try coreData.persistentContainer.viewContext.fetch(request) as? [DirectoryMO] ?? []
        }

        catch {
            fatalError("Error fetching all directories")
        }
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
    
//    private func createDirectories(fromJson jsonDirectories: [[String: AnyObject]]) {
//        var rootDirectories: [DirectoryMO] = []
//
//
//        for jsonDirectory in jsonDirectories {
//
//
//            print("JsonDirectory")
//            print(jsonDirectory)
//
//            let rootDirectory = createDirectory(fromJson: jsonDirectory)
//            rootDirectories.append(rootDirectory)
//
//
////            print("Directory")
////            print(jsonDirectory)
////            print("---------------")
//        }
//
//        print("Root Directory Count")
//        print(rootDirectories.count)
//
//        // Create a diretory
//        // if directory has subDirectories, create them.
//
//    }
//
//    private func createDirectory(fromJson jsonDirectory: [String: AnyObject]) -> DirectoryMO {
//        let newDirectory = DirectoryMO(context: coreData.persistentContainer.viewContext)
//
//
//        newDirectory.id = jsonDirectory["id"] as! Int64
//        newDirectory.name = jsonDirectory["title"] as? String ?? "Untitled"
//
//        if let jsonDocuments = jsonDirectory["files"] as? [[String: AnyObject]] {
//
//            newDirectory.addToDocuments(createDocuments(fromJson: jsonDocuments))
////            let docs = createDocuments(fromJson: jsonDocuments)
//
//            print("DOC COUNT")
//            print(newDirectory.documents!.count)
//
//        }
//
//        if let jsonSubDirectories = jsonDirectory["children"] as? [[String: AnyObject]] {
//            var subDirectories: [DirectoryMO] = []
//
//            print("SubDirectory Count")
//            print(subDirectories.count)
//
//            for jsonSubDirectory in jsonSubDirectories {
//                print("JSON SUB")
//                print(jsonSubDirectory)
//                let subDirectory = createDirectory(fromJson: jsonSubDirectory)
//                subDirectories.append(subDirectory)
//            }
//
//            newDirectory.addToSubDirectories(NSSet(array: subDirectories))
//        }
//
////        newDirectory.subDirectories = subDirectories
//
//        return newDirectory
//
//
//    }
//
//    private func createDocuments(fromJson jsonDocuments: [[String: AnyObject]]) -> NSSet  {
//        var documents: [DocumentMO] = []
//
//        print("CREATE DOCUMENTS")
//        for document in jsonDocuments {
//
//            let newDocument = DocumentMO(context: coreData.persistentContainer.viewContext)
//
//            newDocument.id = document["id"] as! Int64
//            newDocument.title = document["title"] as? String ?? "Untitled"
//            newDocument.url = document["url"] as? String ?? "No URL"
//
////            newDocument.locationOnDisc
//
//
//            documents.append(newDocument)
//
//            print("File")
//            print(document)
//            print("------------")
//        }
//
//        return NSSet(array: documents)
//    }
}
