//
//  StateController.swift
//  Forecourt Documents
//
//  Created by Edwards, Mike on 12/07/2021.
//

import Foundation

class StateController {
    
    //# MARK: - Data:
    var coreData: CoreData = CoreData()
    
    //# MARK: - Controllers:
    let networkController: NetworkController
    let authController: AuthController
    let directoryController: DirectoryController
    let documentController: DocumentController
    
    //# MARK: - Initialisers:
    init() {
        self.networkController = NetworkController(coreData: coreData)
        self.authController = AuthController(coreData: coreData, networkController: networkController)
        self.documentController = DocumentController(coreData: coreData, networkController: networkController)
        self.directoryController = DirectoryController(coreData: coreData, networkController: networkController, documentController: documentController)
    }
}
