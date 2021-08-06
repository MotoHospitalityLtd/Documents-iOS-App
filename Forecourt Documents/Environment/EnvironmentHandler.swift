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
        case .pulse:
            return object(forInfoDictionaryKey: "PulseURL") as! String
        }
    }
    
    var environment: String {
        return object(forInfoDictionaryKey: "Environment") as! String
    }
    
    var pulseURL: String {
        return object(forInfoDictionaryKey: "PulseURL") as! String
    }
    
    var pulseHost: String {
        return object(forInfoDictionaryKey: "PulseHost") as! String
    }
    
    var pulseDomain: String {
        return object(forInfoDictionaryKey: "PulseDomain") as! String
    }

}
