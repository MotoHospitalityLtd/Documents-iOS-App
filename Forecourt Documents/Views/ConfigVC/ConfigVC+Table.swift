//
//  ConfigVC+Table.swift
//  Forecourt Documents
//
//  Created by Edwards, Mike on 21/07/2021.
//

import UIKit

extension ConfigVC: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        print("hostCount: \(stateController.networkController.hosts.count)")
        return stateController.networkController.hosts.count + 1
    }
   
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        // Internet
        case 0:
            return 1
        default:
            return 3
        }
    }
   
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return "INTERNET"
        default:
            return stateController.networkController.hosts[section - 1].name

        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        // Internet
        case 0:
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "DetailCell", for: indexPath)
            cell.isUserInteractionEnabled = false
            
            cell.textLabel!.text = "Status"
            cell.detailTextLabel!.text = internetStatus.rawValue
            
            return cell
            
        default:
            
            switch indexPath.row {
            case 0:
                let cell = tableView.dequeueReusableCell(withIdentifier: "HostURLCell", for: indexPath)
                
                
                cell.textLabel!.text = stateController.networkController.hosts[indexPath.section - 1].shortURL
                
                
                cell.accessoryType = .disclosureIndicator
                return cell
            // STATUS
            case 1:
                let cell = tableView.dequeueReusableCell(withIdentifier: "DetailCell", for: indexPath)
                cell.isUserInteractionEnabled = false
                cell.textLabel!.text = "Status"
                
                print("Host STATUS: \(stateController.networkController.hosts[indexPath.section - 1].status.rawValue)")
                
                cell.detailTextLabel!.text = stateController.networkController.hosts[indexPath.section - 1].status.rawValue
                return cell
            case 2:
                let cell = tableView.dequeueReusableCell(withIdentifier: "ButtonCell", for: indexPath)
                return cell
                
            default:
                return UITableViewCell()
            }
        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.section {
        case 0:
            return
        default:
            switch indexPath.row {
            case 0:
                let selectedHost = stateController.networkController.hosts[indexPath.section - 1]
                performSegue(withIdentifier: "showEditConfigVC", sender: selectedHost)
            case 2:
                self.tableView.deselectSelectedRow(animated: true)
                
                let host = stateController.networkController.hosts[indexPath.section - 1]
                restoreDefaultAlert(forHost: host)
                
            default:
                return
            }
        }
    }
}
