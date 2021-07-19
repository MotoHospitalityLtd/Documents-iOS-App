//
//  NetworkController.swift
//  Forecourt Documents
//
//  Created by Edwards, Mike on 16/07/2021.
//

import UIKit
import MobileCoreServices
import CoreData

//class NetworkController {
//    
//    // HANDLING OF A CURRENT USER TO SET THE TOKEN
//
//    //# MARK: - Data
//    let coreData: CoreData
//    
//    var hosts: [HostMO] = []
//    
//    //# MARK: - Initialisers
//    init(coreData: CoreData) {
//        self.coreData = coreData
//        self.refreshHosts()
//    }
//    
//    func refreshHosts() {
//        hosts = HostMO.loadHosts(coreData: coreData)
//    }
//    
//    //# MARK: - Session
//    func session(host: Host) -> URLSession {
//        let config = URLSessionConfiguration.ephemeral
//        switch host {
//        case .pulse:
//             config.httpAdditionalHeaders = ["Authorization": UserMO.fetchToken(coreData: coreData), "Accept-Encoding": "gzip, deflate", "Accept": "application/json"]
//            
//        case .s3:
//            config.httpAdditionalHeaders = nil
//        }
//
//        return URLSession(configuration: config)
//    }
//    
//    //# MARK: - HTTP Methods
//    func getImage(urlPath: String, data: Data?, _ completion: @escaping (NetworkResponse) -> Void) {
//        
//        let stringURL = urlPath
//        let url: URL = URL(string: stringURL)!
//        
//        print("GET URL: \(url)")
//        
//        var requestURL = URLRequest(url: url)
//        requestURL.httpMethod = "GET"
//        requestURL.timeoutInterval = 30
//        
//        let dataTask = session(host: .s3).dataTask(with: requestURL) {(data, response, error) in
//            let response = self.processResponse(data: data, response: response, error: error)
//            
//            DispatchQueue.main.async {
//                completion(response)
//            }
//        }
//        
//        dataTask.resume()
//    }
//    
//    //# MARK: - HTTP Methods
//    func get(host: Host = .pulse, urlPath: String, data: Data?, _ completion: @escaping (NetworkResponse) -> Void) {
//        
//        let hostIndex = hosts.firstIndex(where: { $0.name == host.rawValue})
//        let stringURL = hosts[hostIndex!].url! + urlPath
//        let url: URL = URL(string: stringURL)!
//        
//        print("GET URL: \(url)")
//        
//        var requestURL = URLRequest(url: url)
//        requestURL.httpMethod = "GET"
//        requestURL.timeoutInterval = 30
//        
//        let dataTask = session(host: Host.init(rawValue: host.rawValue)!).dataTask(with: requestURL) {(data, response, error) in
//            let response = self.processResponse(data: data, response: response, error: error)
//            
//            DispatchQueue.main.async {
//                completion(response)
//            }
//        }
//        
//        dataTask.resume()
//    }
//    
//    func post(host: Host = .pulse, urlPath: String, data: Data?, _ completion: @escaping (NetworkResponse) -> Void) {
//        
//        let hostIndex = hosts.firstIndex(where: { $0.name == host.rawValue})
//        let stringURL = hosts[hostIndex!].url! + urlPath
//        let url: URL = URL(string: stringURL)!
//        
//        print("POST URL: \(url)")
//        
//        var requestURL = URLRequest(url: url)
//        requestURL.timeoutInterval = 30
//        
//        requestURL.setValue("application/json", forHTTPHeaderField: "Content-Type")
//        requestURL.httpMethod = "POST"
//        requestURL.httpBody = data
//        
//        let dataTask = session(host: Host.init(rawValue: host.rawValue)!).dataTask(with: requestURL) {(data, response, error) in
//            let response = self.processResponse(data: data, response: response, error: error)
//            completion(response)
//        }
//        
//        dataTask.resume()
//    }
//    
//    func postForm(host: Host = .pulse, urlPath: String, formData: [String: Any], _ completion: @escaping (NetworkResponse) -> Void) {
//        
//        let hostIndex = hosts.firstIndex(where: { $0.name == host.rawValue})
//        let stringURL = hosts[hostIndex!].url! + urlPath
//        let url: URL = URL(string: stringURL)!
//        
//        print("POST FORM URL: \(url)")
//        
//        let boundary = generateBoundaryString()
//        
//        var requestURL = URLRequest(url: url)
//        requestURL.timeoutInterval = 30
//        requestURL.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
//        requestURL.httpMethod = "POST"
//        requestURL.httpBody = createMultiPartFormData(formData: formData, boundary: boundary)
//        
//        let dataTask = session(host: Host.init(rawValue: host.rawValue)!).dataTask(with: requestURL) {(data, response, error) in
//            let response = self.processResponse(data: data, response: response, error: error)
//            completion(response)
//        }
//        
//        dataTask.resume()
//    }
//    
//    func patch(host: Host = .pulse, urlPath: String, data: Data?, _ completion: @escaping (NetworkResponse) -> Void) {
//        
//        let hostIndex = hosts.firstIndex(where: { $0.name == host.rawValue})
//        let stringURL = hosts[hostIndex!].url! + urlPath
//        let url: URL = URL(string: stringURL)!
//        
//        print("PATCH URL: \(url)")
//        
//        var requestURL = URLRequest(url: url)
//        requestURL.timeoutInterval = 30
//        
//        requestURL.setValue("application/json", forHTTPHeaderField: "Content-Type")
//        requestURL.httpMethod = "PATCH"
//        
//        requestURL.httpBody = data
//        
//        let dataTask = session(host: Host.init(rawValue: host.rawValue)!).dataTask(with: requestURL) {(data, response, error) in
//            let response = self.processResponse(data: data, response: response, error: error)
//            completion(response)
//        }
//        
//        dataTask.resume()
//    }
//    
//    func put(host: Host = .pulse, urlPath: String, data: Data?, _ completion: @escaping (NetworkResponse) -> Void) {
//        
//        let hostIndex = hosts.firstIndex(where: { $0.name == host.rawValue})
//        let stringURL = hosts[hostIndex!].url! + urlPath
//        let url: URL = URL(string: stringURL)!
//        
//        print("PUT URL: \(url)")
// 
//        var requestURL = URLRequest(url: url)
//        requestURL.timeoutInterval = 30
//        
//        requestURL.setValue("application/json", forHTTPHeaderField: "Content-Type")
//        requestURL.httpMethod = "PUT"
//        requestURL.httpBody = data
//        
//        let dataTask = session(host: Host.init(rawValue: host.rawValue)!).dataTask(with: requestURL) {(data, response, error) in
//            let response = self.processResponse(data: data, response: response, error: error)
//            completion(response)
//        }
//        
//        dataTask.resume()
//    }
//    
//    func delete(host: Host = .pulse, urlPath: String, data: Data?, _ completion: @escaping (NetworkResponse) -> Void) {
//        
//        let hostIndex = hosts.firstIndex(where: { $0.name == host.rawValue})
//        let stringURL = hosts[hostIndex!].url! + urlPath
//        let url: URL = URL(string: stringURL)!
//        
//        print("DELETE URL: \(url)")
//        
//        var requestURL = URLRequest(url: url)
//        requestURL.timeoutInterval = 30
//        
//        requestURL.setValue("application/json", forHTTPHeaderField: "Content-Type")
//        requestURL.httpMethod = "DELETE"
//        
//        let dataTask = session(host: Host.init(rawValue: host.rawValue)!).dataTask(with: requestURL) {(data, response, error) in
//            let response = self.processResponse(data: data, response: response, error: error)
//            completion(response)
//        }
//        
//        dataTask.resume()
//    }
//    
//    func createMultiPartFormData(formData: [String: Any], boundary: String) -> Data {
//        var body = Data()
//        
//        for data in formData {
//            body.append(encodeStringForBody("--\(boundary)\r\n"))
//            
//            if let value = data.value as? Data {
//                print(data.key)
//                print("DATA")
//                
//                body.append(encodeStringForBody("Content-Disposition: form-data; name=\"\("\(data.key)")\"; filename=\"\(data.key).jpg\"\r\n"))
//                body.append(encodeStringForBody("Content-Type: \("image/jpeg")\r\n\r\n"))
//                body.append(value)
//                body.append(encodeStringForBody("\r\n"))
//            }
//                
//            else if let value = data.value as? String {
//                print(data.key)
//                print("STRING")
//                body.append(encodeStringForBody("Content-Disposition: form-data; name=\"\("\(data.key)")\"\r\n\r\n"))
//                body.append(encodeStringForBody(value))
//                body.append(encodeStringForBody("\r\n"))
//            }
//                
//            else {
//                print(data.key)
//                print("Different Type")
//                continue
//            }
//        }
//        
//        body.append(encodeStringForBody("--\(boundary)\r\n"))
//        
//        return body
//    }
//    
//    private func generateBoundaryString() -> String {
//        return "Boundary-\(UUID().uuidString)"
//    }
//    
//    private func encodeStringForBody(_ stringToEncode: String) -> Data {
//        var encodedString = Data()
//        encodedString = stringToEncode.data(using: String.Encoding.utf8)!
//        
//        return encodedString
//    }
//    
//    //# MARK: - HTTP Response
//    private func processResponse(data: Data?, response: URLResponse?, error: Error?) -> NetworkResponse {
//        let httpResponse = response as? HTTPURLResponse
//        print("httpResponse Code: \(httpResponse?.statusCode ?? 0)")
//        
//        if httpResponse?.statusCode == nil {
//            return NetworkResponse.error(.noResponse(error!.localizedDescription))
//        }
//        
//        switch(httpResponse!.statusCode) {
//            
//        case 200..<300:
//            print("Successful httpResponse: \(httpResponse!.statusCode)")
//            
//            return NetworkResponse.success(data)
//            
//        case 401:
//            print("Authentication Error")
//            print("httpCode: \(httpResponse!.statusCode)")
//            
//            let uploadResponse = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
//            print("uploadResponse: \(uploadResponse!)")
//            
//            return NetworkResponse.error(.unauthenticated)
//        case 404:
//            print("Not Found Error")
//            print("httpCode: \(httpResponse!.statusCode)")
//            
//            let uploadResponse = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
//            print("uploadResponse: \(uploadResponse!)")
//            
//            return NetworkResponse.error(.notFound)
//            
//        case 422:
//            print("Processing Error")
//            print("httpCode: \(httpResponse!.statusCode)")
//            
//            let uploadResponse = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
//            print("uploadResponse: \(uploadResponse!)")
//            
//            return NetworkResponse.error(.processing)
//            
//        case 423:
//            print("User Account Locked")
//            print("httpCode: \(httpResponse!.statusCode)")
//            
//            let uploadResponse = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
//            print("uploadResponse: \(uploadResponse!)")
//            
//            return NetworkResponse.error(.processing)
//            
//        case 429:
//            print("Too Many Login Attempts")
//            print("httpCode: \(httpResponse!.statusCode)")
//            
//            let uploadResponse = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
//            print("uploadResponse: \(uploadResponse!)")
//            
//            return NetworkResponse.error(.tooManyLoginAttempts)
//            
//        default:
//            print("Unknown error")
//            print("httpCode: \(httpResponse!.statusCode)")
//            
//            let uploadResponse = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
//            print("uploadResponse: \(uploadResponse!)")
//            
//            return NetworkResponse.error(.unknown)
//        }
//    }
//    
//    enum Host: String, CaseIterable  {
//        case pulse = "Pulse"
//        case s3 = "S3"
//        
//        var healthCheckURL: String {
//            switch self {
//                
//            case .pulse: return "/login"
//            case .s3: return "/minio/health/ready"
//                
//            }
//        }
//    }
//}
