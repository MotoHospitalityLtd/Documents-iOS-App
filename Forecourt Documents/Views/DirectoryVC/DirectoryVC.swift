//
//  DirectoryVC2.swift
//  Forecourt Documents
//
//  Created by Edwards, Mike on 13/07/2021.
//

import UIKit

class DirectoryVC: UIViewController, HasBackButton, HasMenuButton {
    func logoutTapped() {
        print("Directory Logout")
    }
    
    //# MARK: - Data
    var stateController: StateController!
    
    //# MARK: - IB Outlets
    @IBOutlet weak var tableView: UITableView!

    var searchController: UISearchController!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("Directory VC View did load")
        
        print("All Documents Count: \(stateController.documentController.allDocuments.count)")
        print("Filter Docs Count: \(stateController.documentController.filteredDocuments.count)")
    
        uiSetup()
    }
    
    //# MARK: - Setup
    private func uiSetup() {
        self.title = stateController.directoryController.currentDirectory!.name
        
        if navigationController!.viewControllers.count > 1 {
            configureBackButton()
        }
        
        configureSearchController()
        configureMenuButton()
    }
    
    
    //# MARK: - Button Actions
    internal func backTapped(sender: UIBarButtonItem) {
        performSegue(withIdentifier: "unwindFromDirectoryVC", sender: self)
    }
    
    func menuTapped(sender: UIBarButtonItem) {
        openMenu(sender: sender, withStateController: stateController)
    }
    
    //# MARK: - Segues
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDocumentVC" {
            let documentVC = segue.destination as! DocumentVC
            documentVC.stateController = stateController
//            searchController.isActive = false
            
        }
       
    }
    
//    func downloadDirectories() {
//        print("Download Directories")
//        stateController.directoryController.downloadDirectories { response in
//            switch response {
//            case .success(_):
//                print("Download directories success")
//            case .error(let httpError):
//                print("Download directories error")
//            }
//        }
//    }
    
    @IBAction func unwindFromDirectoryVC(segue: UIStoryboardSegue) {
        print("Did UnWind from DirectoryVC")
        tableView.deselectSelectedRow(animated: true)
        
        // Reset current directory
        stateController.directoryController.setCurrentDirectory()
        
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
    
    func unwindFromAboutVC(segue: UIStoryboardSegue) {
        
    }
}
