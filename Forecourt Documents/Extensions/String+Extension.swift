//
//  String+Extension.swift
//  Forecourt Documents
//
//  Created by Edwards, Mike on 04/08/2021.
//

import Foundation

extension String {
    func subString(fromIndex: Int, advanceBy: Int) -> String {
        
        let startIndex = self.index(self.startIndex, offsetBy: fromIndex)
        let endIndex = self.index(startIndex, offsetBy: advanceBy)
        
        return String(self[startIndex..<endIndex])
    }
}
