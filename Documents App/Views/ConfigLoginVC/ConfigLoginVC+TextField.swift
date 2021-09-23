//
//  ConfigLoginVC+TextField.swift
//  Forecourt Documents
//
//  Created by Edwards, Mike on 22/07/2021.
//

import UIKit

extension ConfigLoginVC: UITextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        let textField = textField as! PlainTextField

        switch TextField.init(rawValue: textField.tag)! {
        case .dailyPassword:
            dailyPasswordTextField.becomeFirstResponder()
        }
        
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let textField = textField as! PlainTextField
        return textField.shouldAccept(character: string)
    }
    
    enum TextField: Int {
        case dailyPassword = 0
    }
}
