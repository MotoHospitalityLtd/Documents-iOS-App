//
//  EditConfigVC.swift
//  Forecourt Documents
//
//  Created by Edwards, Mike on 21/07/2021.
//

import UIKit

class EditConfigVC: UIViewController, HasBackButton {
    //# MARK: - Data
    var stateController: StateController!
    
    var host: HostMO!
    
    //# MARK: - IB Outlets
    @IBOutlet weak var inputTextField: PlainTextField!

    override func viewDidLoad() {
        super.viewDidLoad()

        uiSetup()
    }
    
    //# MARK: - Setup
    private func uiSetup() {
        self.title = host.name
    
        inputTextField.placeholder = host.shortURL
        configureBackButton()
        inputTextField.becomeFirstResponder()
    }
    
    //# MARK: - Button Actions
    internal func backTapped(sender: UIBarButtonItem) {
        performSegue(withIdentifier: "unwindFromEditConfigVC", sender: self)
    }
    
    @IBAction func saveTapped(_ sender: Any) {
        guard var input = inputTextField.text, !input.isEmpty else {
            emptyFieldAlert()
            
            return
        }
        
        if !input.contains("https://") {
            input = "https://" + input
        }
        
        host.url = input
        stateController.coreData.save(context: stateController.coreData.persistentContainer.viewContext)
        performSegue(withIdentifier: "unwindFromEditConfigVC", sender: self)
    }
}
