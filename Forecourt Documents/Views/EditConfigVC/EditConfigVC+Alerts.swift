//
//  EditConfigVC+Alerts.swift
//  Forecourt Documents
//
//  Created by Edwards, Mike on 04/08/2021.
//

import UIKit

extension EditConfigVC {
    
    //# MARK: - Alerts
    func emptyFieldAlert() {
        let alert = UIAlertController(title: "Empty Field", message: "\n You must enter a \(self.title!.lowercased()) name!", preferredStyle: .alert)
         
         let okAction = UIAlertAction(title: "Ok", style: .default) {(action) in
             
         }
         
         alert.addAction(okAction)
         self.present(alert, animated: true)
    }
}
