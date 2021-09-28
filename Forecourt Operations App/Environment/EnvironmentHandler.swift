//
//  EnvironmentHandler.swift
//  Forecourt Documents
//
//  Created by Edwards, Mike on 21/07/2021.
//

import Foundation

extension Bundle {
    
    func defaultURL(for host: NetworkController.Host) -> String {
        switch host {
        case .documentStorage:
            return object(forInfoDictionaryKey: "DocumentStorageURL") as! String
            
        case .s3:
            return object(forInfoDictionaryKey: "S3URL") as! String
        }
        
    }
    
    var environment: String {
        return object(forInfoDictionaryKey: "Environment") as! String
    }
    
//    var documentStorageURL: String {
//        return object(forInfoDictionaryKey: "DocumentStorageURL") as! String
//    }
//
//    var s3URL: String {
//        return object(forInfoDictionaryKey: "DocumentStorageURL") as! String
//    }
    
//    var pulseHost: String {
//        return object(forInfoDictionaryKey: "PulseHost") as! String
//    }
//
//    var pulseDomain: String {
//        return object(forInfoDictionaryKey: "PulseDomain") as! String
//    }

}
