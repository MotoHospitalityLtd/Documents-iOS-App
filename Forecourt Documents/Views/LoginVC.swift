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
    
    func updateConstraints(forFrameSize size: CGSize) {
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
        updateConstraints(forFrameSize: self.view.frame.size)
        textFieldSetup()
    }
    
    private func textFieldSetup() {
        employeeNumberTextField.becomeFirstResponder()
        
        employeeNumberTextField.configure(withInputRestriction: .number, maxLength: 8)
        dateOfBirthTextField.configure(withInputRestriction: .number, maxLength: 8)
    }
    
    //# MARK: - Button Actions
    @IBAction func loginTapped(_ sender: Any) {
        print("login Tapped")
    }
    
    //# MARK: - Segues
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
       
    }
}
