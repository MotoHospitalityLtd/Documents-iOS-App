//
//  DirectoryVC2.swift
//  Forecourt Documents
//
//  Created by Edwards, Mike on 13/07/2021.
//

import UIKit

class DirectoryVC: UIViewController, HasBackButton, HasMenuButton {
  
    //# MARK: - Data
    var stateController: StateController!
    
    //# MARK: - Variables
    var isRefreshing = false
    
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
        
        refreshControlSetup()
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
    
    //# MARK: - Refresh Control
    func refreshControlSetup() {
        tableView.refreshControl = UIRefreshControl()
        tableView.refreshControl!.addTarget(self, action: #selector(downloadData), for: .valueChanged)
    }
    
    func reSetRefreshControl() {
        tableView.refreshControl!.endRefreshing()
        tableView.refreshControl?.isEnabled = true
        tableView.reloadData()
    }
    
    @objc private func downloadData() {
        
        let spinner = Spinner()
        self.view.addSubview(spinner)

//        self.stateController.clearData()
        
        isRefreshing = true
        
        stateController.directoryController.downloadDirectories { response in
            switch response {
            case .success(_):
                print("Download directories success")
                
                self.stateController.documentController.downloadDocuments { response in
                    switch response {
                    case .success(_ ):
                        print("SUCCESSFULL DOWNLOAD TEST")

                        spinner.close()

                        self.stateController.directoryController.currentDirectory = self.stateController.directoryController.rootDirectory
                        self.stateController.documentController.loadAllDocuments()

                        self.isRefreshing = false

                        self.instantiateDirectoryNC()

                    case .error(let httpError):
                        spinner.close()
                        self.isRefreshing = false

                        if httpError.statusCode == "0" {
                            self.NetworkAlertWithClose()
                        }

                        else {
                            self.httpErrorAlert(httpError: httpError)
                        }
                        print("ERROR DOWNLOADING DIRECTORIES AND PDF DATA")
                    }
                }

            case .error(let httpError):
                spinner.close()
                self.isRefreshing = false
                self.reSetRefreshControl()
                
                if httpError.statusCode == "0" {
                    self.NetworkAlertWithClose()
                }
                    
                else {
                    self.httpErrorAlert(httpError: httpError)
                }
                
                print("Download directories error")
            }
        }
    }
    
    //# MARK: - Navigation
    private func instantiateDirectoryNC() {
        stateController.directoryController.directoryPath = []
        
        if let directoryNC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "DirectoryNC") as? MainNavController, let directoryVC = directoryNC.viewControllers[0] as? DirectoryVC {
            
            directoryVC.stateController = self.stateController
            UIApplication.shared.windows.first?.rootViewController = directoryNC
            UIApplication.shared.windows.first?.makeKeyAndVisible()
        }
    }
    
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
    }
    
    func unwindFromAboutVC(segue: UIStoryboardSegue) {
        
    }
}
