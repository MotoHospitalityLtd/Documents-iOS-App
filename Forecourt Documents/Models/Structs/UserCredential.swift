//
//  UserCredential.swift
//  Forecourt Documents
//
//  Created by Edwards, Mike on 04/08/2021.
//

import Foundation

struct UserCredential: Codable {
    var employeeNumber: String
    var dateOfBirth: String
    
    var encryptedEmployeeNumber: String {
        let cryptionManager = Cryption()
        
        let employeeNumberData = Data(employeeNumber.utf8) // Convert to Data
        let encryptedEmployeeNumber = cryptionManager.encrypt(data: employeeNumberData)! // Encrypt
        return encryptedEmployeeNumber.base64EncodedString() // String Encryption
    }
    
    var encryptedDateOfBirth: String {
        let cryptionManager = Cryption()
        
        let dateOfBirthData = Data(dateOfBirth.utf8) // Convert to Data
        let encryptedDateOfBirth = cryptionManager.encrypt(data: dateOfBirthData)! // Encrypt
        return encryptedDateOfBirth.base64EncodedString() // String Encryption
    }
    
    init(employeeNumber: String, dateOfBirth: String) {
        self.employeeNumber = employeeNumber
        self.dateOfBirth = dateOfBirth
    }
    
    // Restrict codable properties
    private enum CodingKeys: String, CodingKey {
        case employeeNumber
        case dateOfBirth = "password"
    }
}
