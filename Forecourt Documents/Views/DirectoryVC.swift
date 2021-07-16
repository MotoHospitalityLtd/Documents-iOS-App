//
//  DirectoryVC2.swift
//  Forecourt Documents
//
//  Created by Edwards, Mike on 13/07/2021.
//

import UIKit

class DirectoryVC: UIViewController, HasBackButton {
    
    //# MARK: - Data
    var stateController: StateController!
    
    //# MARK: - IB Outlets
    @IBOutlet weak var tableView: UITableView!

    var searchController: UISearchController!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        uiSetup()
    }
    
    //# MARK: - Setup
    private func uiSetup() {
        self.title = stateController.currentDirectory.name
        
        configureBackButton()
        
        
        
       
        configureSearchController()
    }
    
    
    //# MARK: - Button Actions
    internal func backTapped(sender: UIBarButtonItem) {
        performSegue(withIdentifier: "unwindFromDirectoryVC", sender: self)
    }
    
    //# MARK: - Segues
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDocumentVC" {
//            searchController.isActive = false
            
        }
       
    }
    
    @IBAction func unwindFromDirectoryVC(segue: UIStoryboardSegue) {
        print("Did UnWind from DirectoryVC")
        tableView.deselectSelectedRow(animated: true)
        
        // Reset current directory
        stateController.setCurrentDirectory()
        
        // Refresh tableView
        tableView.reloadData()
    }
    
    @IBAction func unwindFromDocumentVC(segue: UIStoryboardSegue) {
        print("UnWind from DocumentVC")
        tableView.deselectSelectedRow(animated: true)
        
//        // Reset current directory
//        stateController.setCurrentDirectory()
//
//        // Refresh tableView
//        tableView.reloadData()
    }
}
