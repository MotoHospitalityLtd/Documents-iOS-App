//
//  HasBackButton.swift
//  Forecourt Documents
//
//  Created by Edwards, Mike on 12/07/2021.
//

import UIKit

// To add a custom back button to a view controller, make it conform to HasBackButton and call configureBackButton() in viewDidLoad.
@objc protocol HasBackButton where Self: UIViewController {
    var navigationItem: UINavigationItem { get }
    @objc func backTapped(sender: UIBarButtonItem)
}

extension HasBackButton {
    func configureBackButton() {
        self.navigationItem.setLeftBarButton(BackButton(sender: self), animated: true)
        self.navigationItem.leftBarButtonItem?.action = #selector(backTapped(sender:))
    }
}

