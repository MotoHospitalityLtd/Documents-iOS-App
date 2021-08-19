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
    
    var currentDocument: DocumentMO?
    
    //# MARK: - Controllers:
    let networkController: NetworkController
    let fileController: FileController
    
    
    //# MARK: - Initialisers
    init(coreData: CoreData, networkController: NetworkController) {
        self.coreData = coreData
        self.networkController = networkController
        self.fileController = FileController(coreData: coreData)
        
        loadAllDocuments()
    }
    
    internal func downloadDocuments(completion: @escaping (NetworkController.NetworkResponse) -> Void) {
        let serialQueue = DispatchQueue(label: "forecourt-documents.data", qos:  .default)
        let group = DispatchGroup()
        
        var downloadItems: [DispatchWorkItem] = []
        var downloadItemNumber = 0
        
        var downloadResponse: NetworkController.NetworkResponse = .success(nil)
        
        let documents = fetchAllDocuments()
        
        for document in documents {
            group.enter()

            let internalDownloadNumber = downloadItemNumber

            let downloadItem = DispatchWorkItem(block: {

                let internalGroup = DispatchGroup()
                internalGroup.enter()

                print("Download A Document")
                self.networkController.getImage(urlPath: document.url!, data: nil) { response in
                    switch response {
                    case .success(let data):

                        print("SUCCESSFULLY DOWNLOADED PDF DATA")
                        
                        self.saveDocument(document: document, data: data!)
                        
                        // do stuff with pdf data... save it locally, set local path for loading.

                        group.leave()
                        internalGroup.leave()

                    case .error(_):
                        print("Error")
                        for downloadItemsIndex in internalDownloadNumber + 1..<downloadItems.count {
                            print("downloadItemsIndex \(downloadItemsIndex)")
                            print("internalDownloadNumber \(downloadItemsIndex)")
                            print("Cancelling internalDownloadNumber \(downloadItemsIndex)")

                            downloadItems[downloadItemsIndex].cancel()
                            group.leave()
                        }

                        downloadResponse = response

                        group.leave()
                        internalGroup.leave()
                    }
                }

                internalGroup.wait()
            })
            
            downloadItems.append(downloadItem)
            serialQueue.async(execute: downloadItem)
            downloadItemNumber = downloadItemNumber + 1
        }
        
        group.notify(queue: DispatchQueue.main) {
            print("Notify")
        
            switch downloadResponse {
            case .success(_):
                print("Notify success")
                completion(.success(nil))
                
            case .error(let httpError):
                print("Notify Error: \(httpError.title)")
                completion(.error(httpError))
            }
        }
    }
    
    internal func removeAllDocuments() {
        for document in fetchAllDocuments() {
            print("Removed document")
            coreData.persistentContainer.viewContext.delete(document)
        }
        
        fileController.removeDirectory(directory: .documents)
        fileController.directorySetup()
    }
    
    internal func loadDocumentData() -> Data {
        
        let documentData = fileController.loadFile(fromPath: currentDocument!.filePath!)
        
        return documentData!
    }
    
    internal func loadAllDocuments() {
        print("Load All Documents")
        self.allDocuments = fetchAllDocuments()
        
        print("All Documents")
        print("Document Count \(allDocuments.count)")
        
        self.filteredDocuments = allDocuments
    }
    
    internal func fetchAllDocuments() -> [DocumentMO] {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "DocumentMO")

        do {
            return try coreData.persistentContainer.viewContext.fetch(request) as? [DocumentMO] ?? []
        }

        catch {
            fatalError("Error fetching all documents")
        }
    }
    
    private func saveDocument(document: DocumentMO, data: Data) {
        print("SAVE FILE")
        
        let documentName = String(document.id) + " " + document.title!
        fileController.saveFile(to: .documents, withName: documentName, fileData: data) { response in
            
            switch response {
            case .success(let filePath):
                print(filePath)
                document.filePath = filePath
                self.coreData.save(context: self.coreData.persistentContainer.viewContext)
                
            case .failure(let error):
                print(error)
            }
        }
    }
}
