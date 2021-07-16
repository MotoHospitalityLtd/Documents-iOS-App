//
//  MenuVC.swift
//  Forecourt Documents
//
//  Created by Edwards, Mike on 13/07/2021.
//

import UIKit

class MenuVC: UIViewController {
    
    //# MARK: - Data
    var stateController: StateController!
    
    //# MARK: - View Functions
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func documentsTapped(_ sender: Any) {
        performSegue(withIdentifier: "showDirectoryVC", sender: self)
    }
    
    //# MARK: - Segues
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDirectoryVC" {
            let directoryVC = segue.destination as! DirectoryVC
            directoryVC.stateController = stateController
            directoryVC.title = "Forecourt Documents"
        }
    }
}

