//
//  LoginVC.swift
//  Forecourt Documents
//
//  Created by Edwards, Mike on 16/07/2021.
//

import UIKit

class LoginVC: UIViewController, HasMenuButton {
    
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

    //# MARK: - Setup
    private func uiSetup() {
        // Update the layout constraints depending on orientation
        updateConstraints(forFrameSize: self.view.frame.size)
        
        // Setup the textFields
        textFieldSetup()
        
        // Hide back button
        self.navigationItem.setHidesBackButton(true, animated: true)
        
        configureMenuButton()
    }
    
    private func textFieldSetup() {
        employeeNumberTextField.becomeFirstResponder()
        
        employeeNumberTextField.configure(withInputRestriction: .number, maxLength: 8)
        dateOfBirthTextField.configure(withInputRestriction: .number, maxLength: 8)
    }
    
    //# MARK: - Button Actions
    @IBAction func loginTapped(_ sender: Any) {
        print("login Tapped")
      
        guard let employeeNumber = employeeNumberTextField.text, !employeeNumber.isEmpty else {
            emptyEmployeeNumberAlert()
            return
        }
    
        guard let dateOfBirth = dateOfBirthTextField.text, !dateOfBirth.isEmpty else {
            emptyDateOfBirthAlert()
            return
        }
        
        self.view.isUserInteractionEnabled = false
        
        // Create a user credential to pass around
        let userCredential = UserCredential(employeeNumber: employeeNumber, dateOfBirth: dateOfBirth)
        loginAttempt(withUserCredential: userCredential)
    }
    
    func menuTapped(sender: UIBarButtonItem) {
        openMenu(sender: sender, withStateController: stateController)
    }
    
    //# MARK: - Network Calls
    private func loginAttempt(withUserCredential userCredential: UserCredential) {
        let spinner = Spinner()
        self.view.addSubview(spinner)
        
        self.stateController.authController.authenticateUser(userCredential: userCredential) { response in
            
            spinner.close()
            
            switch response {
                
            case .newLogin:
                print("New Login")

                
                self.stateController.directoryController.directoryPath = []

                self.downloadData()
                
            case .error(let httpError):
                print("error")
                self.view.isUserInteractionEnabled = true
                
                if httpError.statusCode == "401" {
                    self.authenticationAlert()
                }
                    
                else if httpError.statusCode == "429" {
                    self.tooManyLoginsAlert(httpError: httpError)
                }
                
                else if httpError.statusCode == "0" {
                    self.NetworkAlertWithClose()
                }
                    
                else {
                    self.httpErrorAlert(httpError: httpError)
                }
                
                self.stateController.authController.removeUsers()
            }
        }
    }
    
    private func downloadData() {
        let spinner = Spinner()
        self.view.addSubview(spinner)
        
        stateController.directoryController.downloadDirectories { response in
            
            switch response {
            case .success(_):
                print("Download directories success")
                
                self.stateController.documentController.downloadDocuments { response in
                    switch response {
                    case .success(_ ):
                        print("SUCCESSFULL DOWNLOAD TEST")

                        spinner.close()
                        self.view.isUserInteractionEnabled = true

                        self.stateController.directoryController.currentDirectory = self.stateController.directoryController.rootDirectory
                        self.stateController.documentController.loadAllDocuments()

                        self.instantiateDirectoryNC()

                    case .error(let httpError):
                        spinner.close()
                        self.view.isUserInteractionEnabled = true

                        if httpError.statusCode == "0" {
                            self.NetworkAlertWithClose()
                        }

                        else {
                            self.httpErrorAlert(httpError: httpError)
                        }

                        self.stateController.authController.removeUsers()
                        print("ERROR DOWNLOADING DIRECTORIES AND PDF DATA")
                    }
                }

            case .error(let httpError):
                spinner.close()
                self.view.isUserInteractionEnabled = true
                
                if httpError.statusCode == "0" {
                    self.NetworkAlertWithClose()
                }
                    
                else {
                    self.httpErrorAlert(httpError: httpError)
                }
                
                self.stateController.authController.removeUsers()
                print("Download directories error")
            }
        }
    }
    
    //# MARK: - Navigation
    private func instantiateDirectoryNC() {
        if let directoryNC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "DirectoryNC") as? MainNavController, let directoryVC = directoryNC.viewControllers[0] as? DirectoryVC {
            
            directoryVC.stateController = self.stateController
            UIApplication.shared.windows.first?.rootViewController = directoryNC
            UIApplication.shared.windows.first?.makeKeyAndVisible()
        }
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
        print("SEGUE")
       
    }
    
    func unwindFromAboutVC(segue: UIStoryboardSegue) {

    }
}
