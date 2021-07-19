//
//  LoginVC.swift
//  Forecourt Documents
//
//  Created by Edwards, Mike on 16/07/2021.
//

import UIKit

class LoginVC: UIViewController {
    
    //# MARK: - Data
    var stateController: StateController!

    //# MARK: - IB Outlets
    @IBOutlet weak var employeeNumberTextField: PlainTextField!
    @IBOutlet weak var dateOfBirthTextField: PlainTextField!
    @IBOutlet weak var loginButton: UIButton!
    
    //# MARK: - Constraints
    @IBOutlet weak var logoTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var loginTopConstraint: NSLayoutConstraint!
    
    //# MARK: - View Methods
    override func viewDidLoad() {
        super.viewDidLoad()

        uiSetup()
    }
    
    //# MARK: - Orientation Changes
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        updateConstraints(forFrameSize: size)
    }
    
    private func updateConstraints(forFrameSize size: CGSize) {
        if size.height < 1080 {
            print("Landscape")
            logoTopConstraint.constant = 15
            loginTopConstraint.constant = 13
        }
        
        else {
            print("Portrait")
            logoTopConstraint.constant = 50
            loginTopConstraint.constant = 50
        }
        
        self.view.layoutIfNeeded()
    }

    //# MARK: - Setup
    private func uiSetup() {
        // Update the layout constraints depending on orientation
        updateConstraints(forFrameSize: self.view.frame.size)
        
        // Setup the textFields
        textFieldSetup()
        
        // Hide back button
        self.navigationItem.setHidesBackButton(true, animated: true)
    }
    
    private func textFieldSetup() {
        employeeNumberTextField.becomeFirstResponder()
        
        employeeNumberTextField.configure(withInputRestriction: .number, maxLength: 8)
        dateOfBirthTextField.configure(withInputRestriction: .number, maxLength: 8)
    }
    
    //# MARK: - Button Actions
    @IBAction func loginTapped(_ sender: Any) {
        print("login Tapped")
      
        
        // On a successful login, swapout the loginNC with the directoryNC
        // More handling for later when login screen appears over the top of an active navController and can just pop from the stack if the user is the same as the last logged in user.
        
        
        if let directoryNC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "DirectoryNC") as? UINavigationController, let directoryVC = directoryNC.viewControllers[0] as? DirectoryVC {
            
            directoryVC.stateController = self.stateController
            UIApplication.shared.windows.first?.rootViewController = directoryNC
            UIApplication.shared.windows.first?.makeKeyAndVisible()
            
        }
    }
    
    //# MARK: - Segues
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
       
    }
}
