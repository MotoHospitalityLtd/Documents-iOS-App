//
//  ConfigLoginVC.swift
//  Forecourt Documents
//
//  Created by Edwards, Mike on 21/07/2021.
//

import UIKit

class ConfigLoginVC: UIViewController, HasBackButton {
    //# MARK: - Data
    var stateController: StateController!
    
    //# MARK: - IB Outlets
    @IBOutlet weak var dailyPasswordTextField: PlainTextField!
    @IBOutlet weak var loginButton: UIButton!
    
    //# MARK: - Constraints
    @IBOutlet weak var logoTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var loginTopConstraint: NSLayoutConstraint!

    override func viewDidLoad() {
        super.viewDidLoad()

        uiSetup()
    }
    
    //# MARK: - Setup
    private func uiSetup() {
        configureBackButton()
        
        // Update the layout constraints depending on orientation
        updateConstraints(forFrameSize: self.view.frame.size)
        
        // Setup the textField
        textFieldSetup()
        
        configureBackButton()
    }
    
    private func textFieldSetup() {
        dailyPasswordTextField.becomeFirstResponder()
        dailyPasswordTextField.configure(withInputRestriction: .number, maxLength: 6)
    }
    
    //# MARK: - Button Actions
    internal func backTapped(sender: UIBarButtonItem) {
        performSegue(withIdentifier: "unwindFromConfigLoginVC", sender: self)
    }
    
    @IBAction func loginTapped(_ sender: Any) {
        print("login Tapped")
      
        guard let dailyPassword = dailyPasswordTextField.text, !dailyPassword.isEmpty else {
            emptyDailyPasswordAlert()
            return
        }
        
        performSegue(withIdentifier: "showConfigVC", sender: self)
    }
    
    @IBAction func iTapped(_ sender: Any) {
        configInfoAlert()
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
    
    //# MARK: - Segues
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showConfigVC" {
            let configVC = segue.destination as! ConfigVC
            print("hostCount: \(stateController.networkController.hosts.count)")
            print("SET STATE")
            configVC.stateController = self.stateController
        }
    }
}
