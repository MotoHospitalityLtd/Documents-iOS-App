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
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        
        let navController = window?.rootViewController as! TestNC
        
        // If a login screen is already present then don't add another one.
        guard !navController.viewControllers.last!.isKind(of: LoginVC.self) else { return }
        
        let loginVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "LoginVC") as! LoginVC
        loginVC.stateController = stateController
        
        navController.pushViewController(loginVC, animated: false)
        
        window?.snapshotView(afterScreenUpdates: false)
    
    }

}


