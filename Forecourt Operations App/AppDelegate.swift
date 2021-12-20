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
    var stateController: StateController!

    func application(_ application: UIApplication, willFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        
        print("Environment: \(Bundle.main.environment)")
        print("VendorID: \(UIDevice.vendorId)")
        
        // Setup and inject the StateController.
        stateController = StateController()
        
        if let navController = window?.rootViewController as? MainNavController, let loginVC = navController.viewControllers[0] as? LoginVC {
            navController.stateController = self.stateController
            loginVC.stateController = self.stateController
        }
        
        return true
    }
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        return true
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        
        print("Did Enter Background")
        
        // Get the navController and determine which screen should display when the app enters the background.
        let navController = window?.rootViewController as! MainNavController
        navController.stateController = self.stateController
        navController.determineView()
        
        window?.snapshotView(afterScreenUpdates: false)
    }
}
