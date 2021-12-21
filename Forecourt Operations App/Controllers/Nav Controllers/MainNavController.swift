//
//  MainNavController.swift
//  FCT Operations
//
//  Created by Edwards, Mike on 17/12/2021.
//

import UIKit

class MainNavController: UINavigationController {
    
    var stateController: StateController!
    
    func determineView() {
        // If the top view controller is ConfigVC, pop back to ConfigLoginVC.
        if viewControllers.last!.isKind(of: ConfigVC.self) {
            popViewController(animated: true)
          
            return
        }
        
        // If the top view controller is EditConfigVC, pop back twice to ConfigLoginVC.
        if viewControllers.last!.isKind(of: EditConfigVC.self) {
            popViewController(animated: true)
            popViewController(animated: true)

            return
        }
        
        // Return and don't add a login screen for any of the following screens:
        guard !viewControllers.last!.isKind(of: LoginVC.self) else { return }
        guard !viewControllers.last!.isKind(of: AboutVC.self) else { return }
        guard !viewControllers.last!.isKind(of: ConfigLoginVC.self) else { return }
        
        // Otherwise display the login screen
        let loginVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "LoginVC") as! LoginVC
        loginVC.stateController = stateController
        
        self.pushViewController(loginVC, animated: false)
    }
}
