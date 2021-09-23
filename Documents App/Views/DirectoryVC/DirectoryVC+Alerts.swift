//
//  DirectoryVC+Alerts.swift
//  Forecourt Documents
//
//  Created by Edwards, Mike on 13/08/2021.
//

import UIKit

extension DirectoryVC {
    func NetworkAlertWithClose() {
        let alert = UIAlertController(title: "Connection Failure", message: "\n There is a problem connecting to the network. \n \n Please check the WiFi connection and try again.", preferredStyle: .alert)
        let closeAction = UIAlertAction(title: "Close", style: .default) {(action) in
            
        }
        
        alert.addAction(closeAction)
        self.present(alert, animated: true)
    }
    
    func httpErrorAlert(httpError: NetworkController.HttpError) {
        let alert = UIAlertController(title: httpError.title, message: httpError.message, preferredStyle: .alert)
        let closeAction = UIAlertAction(title: "Close", style: .default) {(action) in
            
        }
        
        alert.addAction(closeAction)
        self.present(alert, animated: true)
    }
}
