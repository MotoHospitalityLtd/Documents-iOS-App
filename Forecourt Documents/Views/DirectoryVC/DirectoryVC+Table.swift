//
//  DirectoryVC2+Table.swift
//  Forecourt Documents
//
//  Created by Edwards, Mike on 13/07/2021.
//

import UIKit

extension DirectoryVC: UITableViewDelegate, UITableViewDataSource {

    //# MARK: - Table Functions
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch searchState() {
        case .empty:
            return stateController.directoryController.currentDirectory!.name
        case .hasResults:
            return "Search Results:"
        case .noResults:
            return "No Documents Were Found"
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch searchState() {
        case .empty:
            return stateController.directoryController.currentDirectory!.visibleItems.count
        case .hasResults, .noResults:
            return stateController.documentController.filteredDocuments.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch searchState() {
        case .empty:
            if let directory = stateController.directoryController.currentDirectory!.visibleItems[indexPath.row] as? DirectoryMO {

                let cell = tableView.dequeueReusableCell(withIdentifier: "DirectoryCell", for: indexPath) as! DirectoryCell
                cell.title.text = directory.name

                return cell
            }
            
            else {
                let document = stateController.directoryController.currentDirectory!.visibleItems[indexPath.row] as! DocumentMO

                let cell = tableView.dequeueReusableCell(withIdentifier: "DocumentCell", for: indexPath) as! DocumentCell
                cell.title.text = document.title

                return cell
            }
            
        case .hasResults, .noResults:
            let cell = tableView.dequeueReusableCell(withIdentifier: "DocumentCell", for: indexPath) as! DocumentCell
            cell.title.text = stateController.documentController.filteredDocuments[indexPath.row].title
            return cell

        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch searchState() {
        case .empty:
            print("Tapped directory cell with no active search criteria")
            if let directory = stateController.directoryController.currentDirectory!.visibleItems[indexPath.row] as? DirectoryMO {
                
                print("Visible Items: \(stateController.directoryController.currentDirectory!.visibleItems)")
                
                stateController.directoryController.directoryPath.append(indexPath.row)
                stateController.directoryController.currentDirectory = directory
                
                print("Directory Path: \(stateController.directoryController.directoryPath)")
                
                let directoryVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "DirectoryVC") as! DirectoryVC
                directoryVC.stateController = self.stateController
                
                navigationController!.pushViewController(directoryVC, animated: true)
            }
            
            else {
                // Document Tapped
                // Locate Document or Download it and set it somehwere in StateController
                
                stateController.documentController.currentDocument = stateController.directoryController.currentDirectory!.visibleItems[indexPath.row] as? DocumentMO
                
                performSegue(withIdentifier: "showDocumentVC", sender: self)
            }
            
            
        case .hasResults, .noResults:
            // Document Tapped
            // Locate Document or Download it and set it somehwere in StateController
            print("Tapped a document cell with search criteria active")
            
            stateController.documentController.currentDocument = stateController.documentController.filteredDocuments[indexPath.row]
            
            performSegue(withIdentifier: "showDocumentVC", sender: self)
        }
    }
}
