//
//  LoginVC.swift
//  Forecourt Documents
//
//  Created by Edwards, Mike on 16/07/2021.
//

import UIKit

class LoginVC: UIViewController, HasMenuButton {
    func logoutTapped() {
        
    }
    
    
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
        
        print("VIEWS:", navigationController!.viewControllers.count)
        for view in navigationController!.viewControllers {
            print(view)
        }
        
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
        
        
        // Create a user credential to pass around
        let userCredential = UserCredential(employeeNumber: employeeNumber, dateOfBirth: dateOfBirth)
    
        loginAttempt(withUserCredential: userCredential)
        
        
        
        
        // On a successful login, swapout the loginNC with the directoryNC
        // More handling for later when login screen appears over the top of an active navController and can just pop from the stack if the user is the same as the last logged in user.
    }
    
    func loginAttempt(withUserCredential userCredential: UserCredential) {
        let spinner = Spinner()
        self.view.addSubview(spinner)
        
        self.stateController.authController.authenticateUser(userCredential: userCredential) { response in
            
            spinner.close()
            
            switch response {
            
            case .newLogin:
                print("New Login")
                
                self.stateController.clearData()
                self.downloadDirectories()
                
               

            case .returningUser: // Was the last user that logged in
                print("Returning User")
                
                if self.navigationController!.viewControllers.count > 1 {
                    print("View Check for over 1")
                    self.navigationController!.popViewController(animated: false)
                }

                else {
                    if let directoryNC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "DirectoryNC") as? UINavigationController, let directoryVC = directoryNC.viewControllers[0] as? DirectoryVC {
                        
                        directoryVC.stateController = self.stateController
                        UIApplication.shared.windows.first?.rootViewController = directoryNC
                        UIApplication.shared.windows.first?.makeKeyAndVisible()
                    }
                }
                
            case .error(let httpError):
                print("error")
                
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
            }
        }
    }
    
    func downloadDirectories() {

//        stateController.directoryController.getDocument()

//
//        let url = "https://s3-dev.moto-hospitality.co.uk/dev-document-storage/Wi3hO3Nkg8D0agK8RfpNvejcBfhmrs8SeHRl66fC.pdf?X-Amz-Content-Sha256=UNSIGNED-PAYLOAD&X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Credential=minio%2F20210810%2F%2Fs3%2Faws4_request&X-Amz-Date=20210810T085003Z&X-Amz-SignedHeaders=host&X-Amz-Expires=1800&X-Amz-Signature=41664bdb94a8813c9151d1a1e225ca85c379d4111ff122cb47390067dd7be96d"
//
//
//        stateController.networkController.getImage(urlPath: url, data: nil) { response in
//            switch response {
//            case .success(let data):
//                print("Successful Photo Data")
//                print(data)
//                self.stateController.pdfData = data
//            case .error(let httpError):
//                print("Error: \(httpError)")
//            }
//        }

        stateController.directoryController.downloadDirectories { response in
            switch response {
            case .success(_):
                print("Download directories success")
                
                
                if let directoryNC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "DirectoryNC") as? UINavigationController, let directoryVC = directoryNC.viewControllers[0] as? DirectoryVC {
                    
                    directoryVC.stateController = self.stateController
                    self.stateController.directoryController.currentDirectory = self.stateController.directoryController.rootDirectory
                    
                    
                    self.stateController.documentController.loadAllDocuments()
                  
                    
                    UIApplication.shared.windows.first?.rootViewController = directoryNC
                    UIApplication.shared.windows.first?.makeKeyAndVisible()
                }
                
                
            case .error(let httpError):
                print("Download directories error")
            }
        }

    }
    
    func menuTapped(sender: UIBarButtonItem) {
        openMenu(sender: sender, withStateController: stateController)
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
