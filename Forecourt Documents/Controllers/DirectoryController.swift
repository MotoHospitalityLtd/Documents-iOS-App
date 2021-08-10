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
    
    //# MARK: - Controllers:
    let networkController: NetworkController
    
    //# MARK: - Initialisers
    init(coreData: CoreData, networkController: NetworkController) {
        self.coreData = coreData
        self.networkController = networkController
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
                        
                        self.createDirectories(fromJson: directoryData)
                        
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
    
    private func createDirectories(fromJson jsonDirectories: [[String: AnyObject]]) {
        var rootDirectories: [DirectoryMO] = []
        for jsonDirectory in jsonDirectories {
            
            
            print("JsonDirectory")
            print(jsonDirectory)
            
            let rootDirectory = createDirectory(fromJson: jsonDirectory)
            rootDirectories.append(rootDirectory)
            
            
//            print("Directory")
//            print(jsonDirectory)
//            print("---------------")
        }
        
        print("Root Directory Count")
        print(rootDirectories.count)
        
        // Create a diretory
        // if directory has subDirectories, create them.
        
    }
    
    private func createDirectory(fromJson jsonDirectory: [String: AnyObject]) -> DirectoryMO {
        let newDirectory = DirectoryMO(context: coreData.persistentContainer.viewContext)
        
        
        newDirectory.id = jsonDirectory["id"] as! Int64
        newDirectory.name = jsonDirectory["title"] as? String ?? "Untitled"
        newDirectory.url = "test url not needed?"
        
        
        if let jsonDocuments = jsonDirectory["files"] as? [[String: AnyObject]] {
            
            newDirectory.addToDocuments(createDocuments(fromJson: jsonDocuments))
//            let docs = createDocuments(fromJson: jsonDocuments)
            
            print("DOC COUNT")
            print(newDirectory.documents!.count)
            
        }
        
        if let jsonSubDirectories = jsonDirectory["children"] as? [[String: AnyObject]] {
            var subDirectories: [DirectoryMO] = []
            
            print("SubDirectory Count")
            print(subDirectories.count)
            
            for jsonSubDirectory in jsonSubDirectories {
                print("JSON SUB")
                print(jsonSubDirectory)
                let subDirectory = createDirectory(fromJson: jsonSubDirectory)
                subDirectories.append(subDirectory)
            }
            
            newDirectory.addToSubDirectories(NSSet(array: subDirectories))
        }
        
//        newDirectory.subDirectories = subDirectories
        
        return newDirectory
       
        
    }
    
    private func createDocuments(fromJson jsonDocuments: [[String: AnyObject]]) -> NSSet  {
        var documents: [DocumentMO] = []
        
        print("CREATE DOCUMENTS")
        for document in jsonDocuments {
            
            let newDocument = DocumentMO(context: coreData.persistentContainer.viewContext)
            
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
