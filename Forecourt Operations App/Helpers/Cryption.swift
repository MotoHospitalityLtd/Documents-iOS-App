//
//  Cryption.swift
//  Forecourt Documents
//
//  Created by Edwards, Mike on 04/08/2021.
//

import Foundation
import CommonCrypto

/// Provides AES256-CBC encryption, decryption and key derivation
class Cryption {
    var key: Data = Data()
    let iv = Data([5,2,2,4,5,6,6,6,9,0,1,2,3,4,5,6])
    
    init() {
        self.key = derivateKey(passphrase: "c!j.7j", salt: "%h.j|53")!
    }
    
    /// Provides AES256-CBC encryption on the given data.
    /// - Parameter data: The data to encrypt.
    /// - Returns: The encrypted data string.
    func encrypt(data: Data) -> Data? {
        let outputLength = data.count + kCCBlockSizeAES128
        var outputBuffer = Array<UInt8>(repeating: 0,
                                        count: outputLength)
        var numBytesEncrypted = 0
        let status = CCCrypt(CCOperation(kCCEncrypt),
                             CCAlgorithm(kCCAlgorithmAES),
                             CCOptions(kCCOptionPKCS7Padding),
                             Array(key),
                             kCCKeySizeAES256,
                             Array(iv),
                             Array(data),
                             data.count,
                             &outputBuffer,
                             outputLength,
                             &numBytesEncrypted)
        
        guard status == kCCSuccess else {
            print("Error encrypting: \(status)")
            return nil
        }
        
        let outputBytes = iv + outputBuffer.prefix(numBytesEncrypted)
        
        return Data(outputBytes)
    }

    /// Decrypt AES256-CBC encrypted data.
    /// - Parameter data: The data to decrypt.
    /// - Returns: The dectypted data.
    func decrypt(data cipherData: Data) -> Data? {
        let iv = cipherData.prefix(kCCBlockSizeAES128)
        let cipherTextBytes = cipherData
            .suffix(from: kCCBlockSizeAES128)
        let cipherTextLength = cipherTextBytes.count
       
        var outputBuffer = Array<UInt8>(repeating: 0,
                                        count: cipherTextLength)
        var numBytesDecrypted = 0
        let status = CCCrypt(CCOperation(kCCDecrypt),
                             CCAlgorithm(kCCAlgorithmAES),
                             CCOptions(kCCOptionPKCS7Padding),
                             Array(key),
                             kCCKeySizeAES256,
                             Array(iv),
                             Array(cipherTextBytes),
                             cipherTextLength,
                             &outputBuffer,
                             cipherTextLength,
                             &numBytesDecrypted)
        
        guard status == kCCSuccess else {
            print("Error decrypting: \(status)")
            return nil
        }
        
        let outputBytes = outputBuffer.prefix(numBytesDecrypted)
        
        return Data(outputBytes)
    }
    
    func derivateKey(passphrase: String, salt: String) -> Data? {
        let rounds = UInt32(45_000)
        var outputBytes = Array<UInt8>(repeating: 0,
                                       count: kCCKeySizeAES256)
        let status = CCKeyDerivationPBKDF(
            CCPBKDFAlgorithm(kCCPBKDF2),
            passphrase,
            passphrase.utf8.count,
            salt,
            salt.utf8.count,
            CCPseudoRandomAlgorithm(kCCPRFHmacAlgSHA1),
            rounds,
            &outputBytes,
            kCCKeySizeAES256)
        
        guard status == kCCSuccess else {
            print("Key deviation error: \(status)")
            return nil
        }
        
        return Data(outputBytes)
    }
}

