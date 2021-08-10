//
//  DocumentController.swift
//  Forecourt Documents
//
//  Created by Edwards, Mike on 10/08/2021.
//

import Foundation
import CoreData

class DocumentController {
    
    //# MARK: - Data
    let coreData: CoreData
    
    //# MARK: - Variables
    var allDocuments: [DocumentMO] = []
    var filteredDocuments: [DocumentMO] = []
    
    //# MARK: - Controllers:
    let networkController: NetworkController
    
    //# MARK: - Initialisers
    init(coreData: CoreData, networkController: NetworkController) {
        self.coreData = coreData
        self.networkController = networkController
    }
    
//    internal func downloadDirectories(completion: @escaping (NetworkController.NetworkResponse) -> Void) {
//
//        self.networkController.get(urlPath: "/api/root-directory") { response in
//            DispatchQueue.main.async {
//                switch response {
//                case .success(let data):
//                    print("Success")
//
//                    do {
//                        let decodedData = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as! [String: AnyObject]
//
//                        let directoryData = decodedData["data"] as! [[String: AnyObject]]
//
////                        self.createDirectories(fromJson: directoryData)
//
//
//                        self.rootDirectory = DirectoryMO.createRootDirectory(fromJSon: directoryData, withContext: self.coreData.persistentContainer.viewContext)
//                        self.currentDirectory = self.rootDirectory
//
//                        print("AFTER ADDING")
////                        dump(self.rootDirectory)
//
//                        self.coreData.save(context: self.coreData.persistentContainer.viewContext)
//
////                        print("DATA")
////                        print(directoryData)
//
//
//                        completion(.success(nil))
//                    }
//
//                    catch {
//                        print("catch error: \(error)")
//                    }
//
//                case .error(let httpError):
//                   completion(.error(httpError))
//                }
//            }
//        }
//    }
    
    internal func removeAllDocuments() {
        for document in fetchAllDocuments() {
            
            // Delete file on disc first before removing Managed Object.
            
            
            print("Removed document")
            coreData.persistentContainer.viewContext.delete(document)
        }
    }
    
    private func fetchAllDocuments() -> [DocumentMO] {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "DocumentMO")

        do {
            return try coreData.persistentContainer.viewContext.fetch(request) as? [DocumentMO] ?? []
        }

        catch {
            fatalError("Error fetching all documents")
        }
    }
}
