//
//  ConfigVC+Alerts.swift
//  Forecourt Documents
//
//  Created by Edwards, Mike on 03/08/2021.
//

import UIKit

extension ConfigVC {
    
    //# MARK: - Alerts
    func restoreDefaultAlert(forHost host: HostMO) {
        let alert = UIAlertController(title: "Confirm", message: "\n Are you sure you want to restore the default URL for \(host.name!)?", preferredStyle: .alert)
        
        let noAction = UIAlertAction(title: "No", style: .default) {(action) in
            self.tableView.deselectSelectedRow(animated: true)
        }
        
        let yesAction = UIAlertAction(title: "Yes", style: .default) {(action) in
            
            // Remove host
            host.delete(coreData: self.stateController.coreData)
            
            // Refresh config / restore default
            self.stateController.networkController.refreshHosts()
            
            self.refreshUI()
        }
        
        alert.addAction(noAction)
        alert.addAction(yesAction)
        
        self.present(alert, animated: true)
    }
    
}
