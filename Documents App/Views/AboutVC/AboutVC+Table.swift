//
//  AboutVC+Table.swift
//  Forecourt Documents
//
//  Created by Edwards, Mike on 21/07/2021.
//

import UIKit

extension AboutVC: UITableViewDelegate, UITableViewDataSource {

    //# MARK: - Table Functions
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch SectionType(rawValue: section) {
        case .general:
            return "GENERAL"
        
        case .connectivity:
            return "CONNECTIVITY"
        
        case .none:
            return nil
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch SectionType(rawValue: section) {
        case .general:
            return 3
        case .connectivity:
            return stateController.networkController.hosts.count + 1
        case .none:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch SectionType(rawValue: indexPath.section) {
        case .general:
            let cell = tableView.dequeueReusableCell(withIdentifier: "InfoCell", for: indexPath)
            cell.isUserInteractionEnabled = false
            
            switch indexPath.row {
            case 0:
                let appVersion = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as! String
                
                cell.textLabel!.text = "App Version"
                cell.detailTextLabel!.text = appVersion
            case 1:
                cell.textLabel!.text = "iOS Version"
                cell.detailTextLabel!.text = UIDevice.current.systemVersion
            case 2:
                cell.textLabel!.text = "Device"
                cell.detailTextLabel!.text = UIDevice.modelName
                
            default:
                return UITableViewCell()
            }
            
            return cell
            
        case .connectivity:
            let cell = tableView.dequeueReusableCell(withIdentifier: "HostCell", for: indexPath) as! HostCell
            cell.isUserInteractionEnabled = false

            if indexPath.row == 0 {
                cell.textLabel!.text = "Internet"
                cell.drawStatusIcon(forStatus: internetStatus)
            }

            else {
                let host = stateController.networkController.hosts[indexPath.row - 1]
                cell.textLabel!.text = host.name
                cell.drawStatusIcon(forStatus: host.status)
            }

            return cell
            
        case .none:
            return UITableViewCell()
        }
    }
    
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//
//    }
    
    enum SectionType: Int {
        case general = 0
        case connectivity = 1
    }
}
