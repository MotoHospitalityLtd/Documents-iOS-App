//
//  AppDelegate.swift
//  Forecourt Documents
//
//  Created by Edwards, Mike on 12/07/2021.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var stateController = StateController()

    func application(_ application: UIApplication, willFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        if let navController = window?.rootViewController as? UINavigationController, let loginVC = navController.viewControllers[0] as? LoginVC {
            loginVC.stateController = self.stateController
        }

        return true
    }
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        

        return true
    }

}


