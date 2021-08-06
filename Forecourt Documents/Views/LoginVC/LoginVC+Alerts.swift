//
//  LoginVC+Alerts.swift
//  Forecourt Documents
//
//  Created by Edwards, Mike on 21/07/2021.
//

import UIKit


extension LoginVC {
    func emptyEmployeeNumberAlert() {
        let alert = UIAlertController(title: "Login Failed", message: "\n The employee number field is empty!", preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "Ok", style: .default) {(action) in
            
        }
        
        alert.addAction(okAction)
        self.present(alert, animated: true)
    }

    func emptyDateOfBirthAlert() {
        let alert = UIAlertController(title: "Login Failed", message: "\n The date of birth field is empty!", preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "Ok", style: .default) {(action) in
            
        }
        
        alert.addAction(okAction)
        self.present(alert, animated: true)
    }
    
    func authenticationAlert() {
        let alert = UIAlertController(title: "Login Failed", message: "\n Incorrect username or password. \n \n Please try again.", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .default) {(action) in
            
        }
        
        alert.addAction(okAction)
        self.present(alert, animated: true)
    }
    
    func tooManyLoginsAlert(httpError: NetworkController.HttpError) {
        let alert = UIAlertController(title: httpError.title, message: httpError.message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .default) {(action) in
            
        }
        
        alert.addAction(okAction)
        self.present(alert, animated: true)
    }
    
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
