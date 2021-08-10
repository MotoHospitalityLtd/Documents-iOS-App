//
//  StateController.swift
//  Forecourt Documents
//
//  Created by Edwards, Mike on 12/07/2021.
//

import Foundation

class StateController {
    
    var pdfData: Data?
    
    //# MARK: - Data:
    var coreData: CoreData = CoreData()
    
    //# MARK: - Controllers:
    let networkController: NetworkController
    let authController: AuthController
    let directoryController: DirectoryController
    let documentController: DocumentController
 
    
    var fakeDataProvider = FakeDataProvider()
    
    //# MARK: - Controllers:
//    var directoryPath: [Int] = []
//    var rootDirectory: Directory
//    var currentDirectory: Directory
//
//    var allDocuments: [Document]
//    var filteredDocuments: [Document]
    
    //# MARK: - Initialisers:
    init() {
        self.networkController = NetworkController(coreData: coreData)
        self.authController = AuthController(coreData: coreData, networkController: networkController)
        self.directoryController = DirectoryController(coreData: coreData, networkController: networkController)
        self.documentController = DocumentController(coreData: coreData, networkController: networkController)

//        self.rootDirectory = fakeDataProvider.testCreate()
//        self.currentDirectory = rootDirectory
//
//        allDocuments = fakeDataProvider.allDocuments
//        filteredDocuments = allDocuments
        
//        print("Number of Directories: \(rootDirectory.subDirectories!.count)")
//
//        print("Directory ID's")
//        print(fakeDataProvider.directoryIds)
//
//        print("Document ID's")
//        print(fakeDataProvider.documentIds)
//
//        print("All Documents")
//        for doc in allDocuments {
//            print(doc.title)
//        }
    }
    
    internal func clearData() {
        directoryController.removeAllDirectories()
        documentController.removeAllDocuments()
        
        coreData.save(context: coreData.persistentContainer.viewContext)
    }
    
//    func setCurrentDirectory() {
//        
//        // Array of tapped indexes from visible items (can only be directory)
//        // [0, 0, 1]
//        print("DirectoryPath Before: \(directoryPath)")
//        
//        directoryPath.removeLast(1)
//        
//        print("DirectoryPath After: \(directoryPath)")
//        
//        var position = rootDirectory
//        for index in directoryPath {
//            
//            position = getSubDirectory(ofDirectory: position, withIndex: index)
//            
//        }
//        
//        currentDirectory = position
//    }
//    
//    func getSubDirectory(ofDirectory directory: Directory, withIndex index: Int) -> Directory {
//        return directory.visibleItems[index] as! Directory
//    }
    
//    func createRootDirectories() {
////        rootDirectories = Directory.createFakeDirectory(amount: 3, subDirectories: 1)!
//    }
//    
    // DirectoryVC
    // DocumentVC
    
    
    // Search - Pop all DocumentsVC
    // Navigate - Push another DirectoryVC to the stack.
    
}


class FakeDataProvider {
    var directoryIds: [Int] = []
    var documentIds: [Int] = []
    var allDocuments: [Document] = []
    
    private var newDirectoryId: Int {
        get {
            let id = directoryIds.count + 1
            directoryIds.append(id)
            return id
        }
    }
    
    private var newDocumentId: Int {
        get {
            let id = documentIds.count + 1
            documentIds.append(id)
            return id
        }
    }
    
    
    internal func testCreate() -> Directory {
        return createFakeDirectory(numberOfDocuments: 5, numberOfSubDirectories: 1)
    }
    
    internal func createRootDirectories(amount: Int) -> [Directory] {
        var directories: [Directory] = []
        
        for _ in 1...amount {
            let newDirectory = self.createFakeDirectory()
            directories.append(newDirectory)
        }
        
        return directories
    }
    
    private func createFakeDirectory(numberOfDocuments: Int = Int.random(in: 1...10), numberOfSubDirectories: Int = Int.random(in: 0...2)) -> Directory {
        
        let directoryId = newDirectoryId
        let directoryName = "Directory: \(directoryId)"
        let directoryUrl = "https://forecourt-app/directory \(directoryId)"
        
        var documents: [Document] = []
        
        if numberOfDocuments > 0 {
            for _ in 1...numberOfDocuments {
                let documentId = newDocumentId
                let documentTitle = "Document: \(documentId)"
                
                let newDocument = Document(
                    id: documentId,
                    title: documentTitle,
                    url: "\(directoryName)/\(documentTitle)",
                    locationOnDisc: "Documents/\(directoryId)/\(documentTitle)"
                )
                
                documents.append(newDocument)
                allDocuments.append(newDocument)
            }
        }
        
        var subDirectories: [Directory] = []
        
        if numberOfSubDirectories > 0 {
            for _ in 1...numberOfSubDirectories {
                let newDirectory = createFakeDirectory()
                subDirectories.append(newDirectory)
            }
        }
        
        
        return Directory(id: directoryId, name: directoryName, url: directoryUrl, subDirectories: subDirectories, documents: documents)
        
        
        
        
        //
        //        let ids: [Int] = createDirectoryIds(amount: amount)
        //        let names: [String] = createDirectoryNames(amount: amount)
        //        let urls: [String] = createDirectoryURLs(amount: amount)
        //
        //        for index in 0...(amount - 1) {
        //            let documents = Document.createFakeDocument(amount: numberOfDocuments)
        //            let subDirectories = createFakeDirectory(amount: subDirectories)
        //            let newDirectory = Directory(id: ids[index], name: names[index], url: urls[index], subDirectories: subDirectories, documents: documents)
        //
        //            if subDirectories != nil {
        //
        //                for sub in subDirectories! {
        //                    newDirectory.visibleItems.append(sub)
        //                }
        //
        ////
        ////                newDirectory.visibleItems.append(subDirectories!)
        //            }
        //
        //            for doc in documents {
        //                newDirectory.visibleItems.append(doc)
        //            }
        //
        //
        //
        //
        //
        //
        //            print("TEST")
        //            print(newDirectory.visibleItems)
        //
        //            directories.append(newDirectory)
        //        }
        //
        //        return directories
        //    }

    }
    
    
//    private static func createFakeDirectory(amount: Int = 1, numberOfDocuments: Int = Int.random(in: 1...20), subDirectories: Int = Int.random(in: 0...1)) -> [Directory]?) {
//
//
//    }
    
    
    
    
}

// Search Document
// Array with all documents in
// All Documents
// Filtered Documents


class Directory {
    var id: Int
    var name: String
    var url: String
    var subDirectories: [Directory]?
    var documents: [Document]?
    
    var visibleItems: [Any] = []

    init(id: Int, name: String, url: String, subDirectories: [Directory]?, documents: [Document]?) {
        self.id = id
        self.name = name
        self.url = url
        self.subDirectories = subDirectories
        self.documents = documents
        setVisibleItems()
    }
    
    private func setVisibleItems() {
        visibleItems = subDirectories! + documents!
        
        
//        print("Visible Items on Directory \(id):")
//
//        for x in visibleItems {
//            if let y = x as? Directory {
//
//                print(y.name)
//            }
//            
//            else {
//                let z = x as! Document
//                print(z.title)
//            }
//        }
//
//        print("")
//        print("")
    }
}


class Document {
    var id: Int
    var title: String
    var url: String
    var locationOnDisc: String

    init(id: Int, title: String, url: String, locationOnDisc: String) {
        self.id = id
        self.title = title
        self.url = url
        self.locationOnDisc = locationOnDisc
    }
}


//class Directory {
//    var id: Int
//    var name: String
//    var url: String
//    var subDirectories: [Directory]?
//    var documents: [Document]?
//    var visibleItems: [Any] = []
//
//    init(id: Int, name: String, url: String, subDirectories: [Directory]?, documents: [Document]? ) {
//        self.id = id
//        self.name = name
//        self.url = url
//        self.subDirectories = subDirectories
//        self.documents = documents
//    }
//
//
//
//    static func createFakeDirectory(amount: Int = 1, numberOfDocuments: Int = Int.random(in: 1...20), subDirectories: Int = Int.random(in: 0...1)) -> [Directory]? {
//
//        guard amount > 0 else { return nil }
//
//        var directories: [Directory] = []
//
//        let ids: [Int] = createDirectoryIds(amount: amount)
//        let names: [String] = createDirectoryNames(amount: amount)
//        let urls: [String] = createDirectoryURLs(amount: amount)
//
//        for index in 0...(amount - 1) {
//            let documents = Document.createFakeDocument(amount: numberOfDocuments)
//            let subDirectories = createFakeDirectory(amount: subDirectories)
//            let newDirectory = Directory(id: ids[index], name: names[index], url: urls[index], subDirectories: subDirectories, documents: documents)
//
//            if subDirectories != nil {
//
//                for sub in subDirectories! {
//                    newDirectory.visibleItems.append(sub)
//                }
//
////
////                newDirectory.visibleItems.append(subDirectories!)
//            }
//
//            for doc in documents {
//                newDirectory.visibleItems.append(doc)
//            }
//
//
//
//
//
//
//            print("TEST")
//            print(newDirectory.visibleItems)
//
//            directories.append(newDirectory)
//        }
//
//        return directories
//    }
//
//    // Create some fake directory ids
//    private static func createDirectoryIds(amount: Int) -> [Int] {
//        var ids: [Int] = []
//
//        for id in 1...amount {
//            ids.append(id)
//        }
//
//        return ids
//    }
//
//    // Create some fake directory names
//    private static func createDirectoryNames(amount: Int) -> [String] {
//        var names: [String] = []
//
//        for number in 1...amount {
//            names.append("Directory Name \(String(number))")
//        }
//
//        return names
//    }
//
//    // Create some fake directory URL's
//    private static func createDirectoryURLs(amount: Int) -> [String] {
//        var urls: [String] = []
//
//        for number in 1...amount {
//            urls.append("https://forecourt-app/directory \(String(number))")
//        }
//
//        return urls
//    }
//}
//
//class Document {
//    var id: Int
//    var title: String
//    var url: String
//    var locationOnDisc: String
//
//    init(id: Int, title: String, url: String, locationOnDisc: String) {
//        self.id = id
//        self.title = title
//        self.url = url
//        self.locationOnDisc = locationOnDisc
//    }
//
//
//    // Create some fake documents
//    static func createFakeDocument(amount: Int = 1) -> [Document] {
//        var documents: [Document] = []
//
//        let ids: [Int] = createDocumentIds(amount: amount)
//        let titles: [String] = createDocumentTitles(amount: amount)
//        let urls: [String] = createDocumentURLs(amount: amount)
//        let locationsOnDisc: [String] = createDocumentLocationsOnDisk(amount: amount)
//
//        for index in 0...(amount - 1) {
//            let newDocument = Document(id: ids[index], title: titles[index], url: urls[index], locationOnDisc: locationsOnDisc[index])
//            documents.append(newDocument)
//        }
//
//
//
//        return documents
//
//    }
//
//    // Create some fake document ids
//    private static func createDocumentIds(amount: Int) -> [Int] {
//        var ids: [Int] = []
//
//        for id in 1...amount {
//            ids.append(id)
//        }
//
//        return ids
//    }
//
//    // Create some fake document titles
//    private static func createDocumentTitles(amount: Int) -> [String] {
//        var titles: [String] = []
//
//        for number in 1...amount {
//            titles.append("Document Title \(String(number))")
//        }
//
//        return titles
//    }
//
//    // Create some fake document URL's
//    private static func createDocumentURLs(amount: Int) -> [String] {
//        var urls: [String] = []
//
//        for number in 1...amount {
//            urls.append("https://forecourt-app/documents/Document Title \(String(number))")
//        }
//
//        return urls
//    }
//
//    // Create some fake document locations
//    private static func createDocumentLocationsOnDisk(amount: Int) -> [String] {
//        var locationsOnDisc: [String] = []
//
//        for number in 1...amount {
//            locationsOnDisc.append("documents/Document Title \(String(number))")
//        }
//
//        return locationsOnDisc
//    }
//}
