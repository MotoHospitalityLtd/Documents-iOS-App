//
//  NetworkController+Responses.swift
//  Forecourt Documents
//
//  Created by Edwards, Mike on 16/07/2021.
//

import Foundation

extension NetworkController {
    enum NetworkResponse {
        case success(Data?)
        case error(HttpError)
    }
    
    enum HttpError {
        case unauthenticated
        case noResponse(String?)
        case processing
        case userLocked
        case tooManyLoginAttempts
        case notFound
        case unknown
        
        var title: String {
            switch self {
            case .unauthenticated:
                return "Authentication Error(401)"
            case .notFound:
                return "Not Found (404)"
            case .processing:
                return "Processing Error (422)"
            case .userLocked:
                return "User Account Locked"
            case .tooManyLoginAttempts:
                return "Too Many Login Attempts"
            case .noResponse:
                return "Connection Failure"
            case .unknown:
                return "Unknown Error"
            }
        }
        
        var message: String {
            switch self {
            case .unauthenticated:
                return "\n 'This device has not been authenticated.' \n \n Please contact IT Support."
            case .notFound:
                return "\n 'The requested resource could not be found on the server.' \n \n If problems persist, please contact IT Support."
            case .processing:
                return "\n 'An error occurred while processing the request.' \n \n If problems persist, please contact IT Support."
            case .userLocked:
                return "\n Please contact IT Support."
            case .tooManyLoginAttempts:
                return "\n Please try again shortly."
            case .noResponse(let error):
                if error != nil {
                    print("No response error: \(error!)")
                }
                
                return "\n There is a problem connecting to the network. \n \n Please check the WiFi connection and tap 'Retry'."
            case .unknown:
                return "\n 'An unknown error occurred.' \n \n If problems persist, please contact IT Support."
            }
        }
        
        var statusCode: String? {
            switch self {
            case .unauthenticated:
                return "401"
            case .notFound:
                return "404"
            case .processing:
                return "422"
            case .userLocked:
                return "423"
            case .tooManyLoginAttempts:
                return "429"
            case .noResponse:
                return "0"
            case .unknown:
                return "999"
            }
        }
    }
}

