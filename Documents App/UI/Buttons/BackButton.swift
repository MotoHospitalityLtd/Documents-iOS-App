//
//  BackButton.swift
//  Forecourt Documents
//
//  Created by Edwards, Mike on 12/07/2021.
//

import UIKit

class BackButton: UIBarButtonItem {
    init(sender: UIViewController) {
        super.init()
        
        self.image = UIImage(systemName: "chevron.backward")
        self.style = .plain
        self.target = sender
        self.imageInsets = UIEdgeInsets(top: 2, left: -8, bottom: 0, right: 0)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
