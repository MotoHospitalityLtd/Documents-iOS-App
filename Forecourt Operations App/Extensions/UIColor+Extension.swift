//
//  UIColor+Extension.swift
//  Forecourt Documents
//
//  Created by Edwards, Mike on 23/07/2021.
//

import UIKit

//# MARK: - Custom Colours:
extension UIColor {
    static let detailText = UIColor(fromHex: "9A9A9A")
    static let buttonBlue = UIColor(fromHex: "007AFF")
    static let navBarShadow = UIColor(fromHex: "A7A7AA")
}

//# MARK: - Colour From Hex:
extension UIColor {
    convenience init(fromHex hexString: String) {
        let redComponent = hexString[hexString.startIndex..<hexString.index(hexString.startIndex, offsetBy: 2)]
        let greenComponent = hexString[hexString.index(hexString.startIndex, offsetBy: 2)..<hexString.index(hexString.startIndex, offsetBy: 4)]
        let blueComponent = hexString[hexString.index(hexString.startIndex, offsetBy: 4)..<hexString.index(hexString.startIndex, offsetBy: 6)]
        
        self.init(red: CGFloat(Float(Int(redComponent, radix: 16)!) / 255), green: CGFloat(Float(Int(greenComponent, radix: 16)!) / 255), blue: CGFloat(Float(Int(blueComponent, radix: 16)!) / 255), alpha: CGFloat(1.0))
    }
}
