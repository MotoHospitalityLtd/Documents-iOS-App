//
//  HostCell.swift
//  Forecourt Documents
//
//  Created by Edwards, Mike on 23/07/2021.
//

import UIKit

class HostCell: UITableViewCell {

    @IBOutlet weak var statusIcon: UIImageView!
    
    func drawStatusIcon(forStatus status: HostMO.Status) {
        statusIcon.image?.withRenderingMode(.alwaysTemplate)
        statusIcon.tintColor = UIColor.init(fromHex: status.iconColour)
    }
}
