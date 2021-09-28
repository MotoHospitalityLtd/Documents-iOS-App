//
//  UITableView+Extension.swift
//  Forecourt Documents
//
//  Created by Edwards, Mike on 12/07/2021.
//

import UIKit

extension UITableView {
    // De-select a currently selected row.
    func deselectSelectedRow(animated: Bool) {
        guard let indexPathForSelectedRow = self.indexPathForSelectedRow else {return}
        self.deselectRow(at: indexPathForSelectedRow, animated: animated)
    }
    
    // Scroll to the top of a table view.
    func scrollToTop() {
        
        guard numberOfSections > 0 else { return }
        guard numberOfRows(inSection: 0) > 0 else { return }
        
        self.scrollToRow(at: [0,0], at: .top, animated: false)
    }
}

