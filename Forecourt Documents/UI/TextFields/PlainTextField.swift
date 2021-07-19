//
//  PlainTextField.swift
//  Forecourt Documents
//
//  Created by Edwards, Mike on 16/07/2021.
//

import UIKit

class PlainTextField: UITextField {
    
    var maxLength = 0
    var inputRestriction: InputRestriction?
    
    var shouldChangeCharacter: Bool {
        get {
            return true
        }
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        setup()
    }

    private func setup() {
        turnOffKeyboardIcons()
        setLeftPadding(10)
    }
    
    private func turnOffKeyboardIcons() {
        // Turn off icons above the keyboard.
        inputAssistantItem.leadingBarButtonGroups = []
        inputAssistantItem.trailingBarButtonGroups = []
    }
    
    private func setLeftPadding(_ amount: CGFloat){
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.leftView = paddingView
        self.leftViewMode = .always
    }
    
    internal func configure(withInputRestriction inputRestriction: InputRestriction?, maxLength: Int) {
        self.inputRestriction = inputRestriction
        self.maxLength = maxLength
    }
    
    internal func shouldAccept(character: String) -> Bool {
        
        // Always accept the delete character
        if strcmp(character, "\\b") == -92 {
            return true
        }

        // If there is an inputRestriction, check the entered character is allowed and make sure the text length is below the set maxLength.
        return inputRestriction?.allowedCharacters.contains(character) ?? true && text!.count < maxLength
    }
    
    override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        return false
    }
    
    enum InputRestriction {
        case number
       
        var allowedCharacters: String {
            switch self {
            case .number:
                return "0123456789"
            }
        }
    }
}
