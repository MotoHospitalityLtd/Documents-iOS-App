//
//  LoginVC.swift
//  Forecourt Documents
//
//  Created by Edwards, Mike on 16/07/2021.
//

import UIKit

@objc class TestNC: UINavigationController, HasMenuButton {
    
    init() {
        
        super.init(nibName: nil, bundle: nil)
        configureMenuButton()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    
    func menuTapped(sender: UIBarButtonItem) {
        print("Menu Tapped")
    }
    
    
    @objc func testTap(_ sender: Any) {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        alert.modalPresentationStyle = .popover
        
        let aboutAction = UIAlertAction(title: "About", style: .default) {action in
           
        }
       
        
        let quickStartMenu = UIAlertAction(title: "Logout", style: .default) {action in
           
        }
        
        alert.addAction(aboutAction)
        alert.addAction(quickStartMenu)
        
//        alert.popoverPresentationController?.barButtonItem = sender

        // Present the AlertController
//        self.present(alert, animated: true) {
//            
//        }
    }
    
}

class MenuButton: UIBarButtonItem {
    init(sender: UIViewController) {
        super.init()
        
        self.image = UIImage(systemName: "line.horizontal.3.decrease")
        self.style = .plain
        self.target = sender
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func testtTap(sender: Any) {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        alert.modalPresentationStyle = .popover
        
        let aboutAction = UIAlertAction(title: "About", style: .default) {action in
           
        }
       
        
        let quickStartMenu = UIAlertAction(title: "Logout", style: .default) {action in
           
        }
        
        alert.addAction(aboutAction)
        alert.addAction(quickStartMenu)
        
//        alert.popoverPresentationController?.barButtonItem = sender

        // Present the AlertController
//        self.present(alert, animated: true) {
//
//        }
    }
}

@objc protocol HasMenuButton where Self: TestNC {
    var navigationItem: UINavigationItem { get }
    @objc func menuTapped(sender: UIBarButtonItem)
}

extension HasMenuButton {
    
     func configureMenuButton() {
        self.navigationItem.setRightBarButton(MenuButton(sender: self), animated: true)
        self.navigationItem.rightBarButtonItem?.action = #selector(menuTapped(sender:))
     
//         self.navController = navigationController as! TestNC
        
        
//        self.navigationItem.rightBarButtonItem?.action = #selector(testBB.testtTap(sender: self))
        
//        self.navigationItem.rightBarButtonItem?.action = #selector(Self.testMenu)
        
        print("Self.self: \(Self.self)")
        print("self: \(self)")
        print("parent: \(self.parent!)")
    }
    
 
    
}

class BaseViewController: UIViewController, HasBackButton {
    func backTapped(sender: UIBarButtonItem) {
        print("Back Tapped")
    }
    
    
    
    func addMenu() {
        self.navigationItem.setRightBarButton(MenuButton(sender: self), animated: true)
        self.navigationItem.rightBarButtonItem?.action = #selector(menuTapped(sender:))
        
    }
    
    @objc func menuTapped(sender: UIBarButtonItem) {
        print("Menu Tapped")
    }
    
}

class LoginVC: BaseViewController {
   
    
//    func menuTapped(sender: UIBarButtonItem) {
//        print("Menu Tapped")
//
//        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
//
//        alert.modalPresentationStyle = .popover
//
//        let aboutAction = UIAlertAction(title: "About", style: .default) {action in
//
//        }
//
//
//        let quickStartMenu = UIAlertAction(title: "Logout", style: .default) {action in
//
//        }
//
//        alert.addAction(aboutAction)
//        alert.addAction(quickStartMenu)
//
//        alert.popoverPresentationController?.barButtonItem = sender
//
//        // Present the AlertController
//        self.present(alert, animated: true) {
//
//        }
//    }
    
    //# MARK: - Data
    var stateController: StateController!

    //# MARK: - IB Outlets
    @IBOutlet weak var employeeNumberTextField: PlainTextField!
    @IBOutlet weak var dateOfBirthTextField: PlainTextField!
    @IBOutlet weak var loginButton: UIButton!
    
    //# MARK: - Constraints
    @IBOutlet weak var logoTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var loginTopConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var logo: UIImageView!
    //# MARK: - View Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        configureMenuButton()
        
        addMenu()
        configureBackButton()

        logo.tintAdjustmentMode = .normal
        
        uiSetup()
    }
    
    override func backTapped(sender: UIBarButtonItem) {
        print("OVER RIDE BACL")
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
        
        if navigationController!.viewControllers.count > 1 {
            navigationController!.popViewController(animated: false)
        }
        
        else {
            if let directoryNC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "DirectoryNC") as? TestNC, let directoryVC = directoryNC.viewControllers[0] as? DirectoryVC {
                
                directoryVC.stateController = self.stateController
                UIApplication.shared.windows.first?.rootViewController = directoryNC
                UIApplication.shared.windows.first?.makeKeyAndVisible()
                
            }
        }
    }
    
    //# MARK: - Segues
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
       
    }
}
