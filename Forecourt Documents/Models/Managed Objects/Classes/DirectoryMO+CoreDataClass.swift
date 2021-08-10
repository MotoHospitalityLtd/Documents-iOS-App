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
    
    var visibleItems: [Any] = []

    private func setVisibleItems() {
        let subDirectories = subDirectories?.allObjects as? [DirectoryMO]
        let documents = documents?.allObjects as? [DocumentMO]
        
        visibleItems = subDirectories! + documents!
    }
}
