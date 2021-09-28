//
//  FileController.swift
//  Forecourt Documents
//
//  Created by Edwards, Mike on 12/08/2021.
//

import Foundation
import CoreData

class FileController {
    
    //# MARK: - Data
    let coreData: CoreData
    
    //# MARK: - Variables
    let documentsDirectory: URL
    
    //# MARK: - Controllers:
    let fileManager = FileManager()
    
    //# MARK: - Initialisers
    init(coreData: CoreData) {
        self.coreData = coreData
       
        documentsDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first!
        directorySetup()
    }
    
    func saveFile(to directory: SaveDirectory, withName filename: String, fileData: Data, completion: @escaping (SaveResult) -> Void) {
        print("Directory to save file: \(directory)")

        let saveDestination = documentsDirectory.appendingPathComponent(directory.rawValue).appendingPathComponent(filename)

        do {
            try fileData.write(to: saveDestination)
            print("Saved")
            completion(.success(directory.rawValue + "/" + filename))
        }

        catch {
            print("Problem saving file: \(error)")
            completion(.failure(error))
        }
    }
    
    func directorySetup() {
        for directory in SaveDirectory.allCases {
            let directoryPath = documentsDirectory.path + directory.rawValue
            
            if pathExists(path: directoryPath) != true {
                print("\(directory.rawValue) does not exist")
                createDirectory(atPath: directoryPath)
            }
        }
    }
    
    func pathExists(path: String) -> Bool {
        if fileManager.fileExists(atPath: path) {
            print("\(path) path exists.")
            return true
        }

        else {
            print("\(path) path not found.")
            return false
        }
    }
    
    func createDirectory(atPath path: String) {
        do {
            try fileManager.createDirectory(atPath: path, withIntermediateDirectories: true, attributes: nil)
            print("\(path) has been created.")
        }

        catch {
            print("Error creating \(path): \(error.localizedDescription)")
        }
    }
    
    func removeDirectory(directory: SaveDirectory) {
        let directoryPath = documentsDirectory.path + directory.rawValue
        
        if pathExists(path: directoryPath) {
            do {
                print("Directory exists")
                try fileManager.removeItem(atPath: directoryPath)
                print("Directory: \(directoryPath) has been removed")
            }
                
            catch {
                print("\(directoryPath) could not be removed")
            }
        }
    }
    
    func loadFile(fromPath path: String) -> Data? {
        print("LOAD FILE")
        let fullPath = documentsDirectory.path + path
        
        if pathExists(path: fullPath) {
            print("PATH EXISTS ATTEMPT LOAD")
            do {
                let fileData = try Data(contentsOf: documentsDirectory.appendingPathComponent(path))
                return fileData
//                return UIImage(data: imageData)!
            }
            
            catch {
                print("Not able to load image")
            }
        }
        
        else {
            print("PATH DOES NOT EXIST")
        }
        
        return nil
    }
        
    enum SaveDirectory: String, CaseIterable {
        case documents = "/documents"
    }
    
    enum SaveResult {
        case success(String)
        case failure(Error)
    }
}
