//
//  HostCell.swift
//  Forecourt Documents
//
//  Created by Edwards, Mike on 23/07/2021.
//

import UIKit

class HostCell: UITableViewCell {

    func drawStatusIcon(forStatus status: HostMO.Status) {
        let circleLayer = CAShapeLayer()
        circleLayer.path = UIBezierPath(ovalIn: CGRect(x: 293, y: 16, width: 12, height: 12)).cgPath
        circleLayer.fillColor = UIColor.init(fromHex: status.iconColour).cgColor
        self.contentView.layer.addSublayer(circleLayer)
    }
    
}
