//
//  HasMenuButton.swift
//  Forecourt Documents
//
//  Created by Edwards, Mike on 21/07/2021.
//

import UIKit

@objc protocol HasMenuButton where Self: UIViewController {
    var navigationItem: UINavigationItem { get }
    @objc func menuTapped(sender: UIBarButtonItem)
    func unwindFromAboutVC(segue: UIStoryboardSegue)
}

extension HasMenuButton {
     internal func configureMenuButton() {
        // Create and display the menu button.
        self.navigationItem.setRightBarButton(MenuButton(sender: self), animated: true)
        self.navigationItem.rightBarButtonItem?.action = #selector(menuTapped(sender:))
        
        // Prevent colour change when popover shows (still dims slightly)
        self.view.tintAdjustmentMode = .normal
    }
    
    internal func openMenu(sender: UIBarButtonItem, withStateController stateController: StateController) {
        let menu = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)

        menu.modalPresentationStyle = .popover

        // Menu Buttons & actions
        let aboutAction = UIAlertAction(title: "About", style: .default) {action in
            let aboutVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "AboutVC") as! AboutVC
            aboutVC.stateController = stateController

            self.navigationController!.pushViewController(aboutVC, animated: true)
        }

        let logOutAction = UIAlertAction(title: "Logout", style: .default) {action in
            print("Logout Tapped")
        }

        menu.addAction(aboutAction)
        menu.addAction(logOutAction)

        // Select the location of the popover
        menu.popoverPresentationController?.barButtonItem = sender
    
        // Present the menu
        self.present(menu, animated: true) {
    
        }
    }
    
}
