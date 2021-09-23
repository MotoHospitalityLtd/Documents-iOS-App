//
//  MenuButton.swift
//  Forecourt Documents
//
//  Created by Edwards, Mike on 21/07/2021.
//

import UIKit

class MenuButton: UIBarButtonItem {
    init(sender: UIViewController) {
        super.init()
        
        self.image = UIImage(systemName: "line.horizontal.3.decrease")
        self.style = .plain
        self.target = sender
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
