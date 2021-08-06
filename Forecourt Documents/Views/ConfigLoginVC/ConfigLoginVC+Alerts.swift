//
//  ConfigLoginVC+Alerts.swift
//  Forecourt Documents
//
//  Created by Edwards, Mike on 22/07/2021.
//

import UIKit


extension ConfigLoginVC {
    func emptyDailyPasswordAlert() {
        let alert = UIAlertController(title: "Login Failed", message: "\n The daily password field is empty!", preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "Ok", style: .default) {(action) in
            
        }
        
        alert.addAction(okAction)
        self.present(alert, animated: true)
    }
    
    func configInfoAlert() {
        let alert = UIAlertController(title: "Config", message: "\n To access and amend config, please contact IT Support for a daily password.", preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "Ok", style: .default) {_ in
            
        }
        
        alert.addAction(okAction)
        self.present(alert, animated: true)
    }
}
