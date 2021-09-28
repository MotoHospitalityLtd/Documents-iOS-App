//
//  Data+Extension.swift
//  Forecourt Documents
//
//  Created by Edwards, Mike on 06/08/2021.
//

import Foundation

extension Data {
    func printJSON() {
        let json = NSString(data: self, encoding: String.Encoding.utf8.rawValue)
        print(json!)
    }
}
