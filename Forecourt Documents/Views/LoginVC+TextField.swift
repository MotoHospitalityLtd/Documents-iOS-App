//
//  LoginVC+TextField.swift
//  Forecourt Documents
//
//  Created by Edwards, Mike on 18/07/2021.
//

import UIKit

extension LoginVC: UITextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        let textField = textField as! PlainTextField

        switch TextField.init(rawValue: textField.tag)! {
        case .employeeNumber:
            dateOfBirthTextField.returnKeyType = .next
            dateOfBirthTextField.becomeFirstResponder()

        case .dateOfBirth:
            dateOfBirthTextField.returnKeyType = .search
            loginTapped(self)
        }

        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let textField = textField as! PlainTextField
        return textField.shouldAccept(character: string)
    }
    
    enum TextField: Int {
        case employeeNumber = 0
        case dateOfBirth = 1
    }
}
