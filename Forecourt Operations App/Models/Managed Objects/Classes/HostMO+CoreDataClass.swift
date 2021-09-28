//
//  HostMO+CoreDataClass.swift
//  Forecourt Documents
//
//  Created by Edwards, Mike on 21/07/2021.
//
//

import Foundation
import CoreData

@objc(HostMO)
public class HostMO: NSManagedObject {
    var shortURL: String {
        get {
            return url!.replacingOccurrences(of: "https://", with: "")
        }
    }

    var hasResponded: Bool = false
    
    var status: Status = .connecting {
        didSet {
            if status == .connecting {
                self.hasResponded = false
            }
            
            else {
                self.hasResponded = true
            }
        }
    }
    
    func healthCheck(networkController: NetworkController, _ completion: @escaping (Bool) -> Void) {
        let healthCheckURL = NetworkController.Host.init(rawValue: self.name!)!.healthCheckURL
        let host = NetworkController.Host.init(rawValue: self.name!)!
        
        networkController.get(host: host, urlPath: healthCheckURL, data: nil) { (response) in
            switch response {
            case .success(_):
                print("SUCCESS")
                self.status = .online
            case .error(let error):
                print("ERROR \(error)")
                self.status = .offline
            }
            DispatchQueue.main.async {
            completion(true)
            }
        }
    
    }
    
    static func loadHosts(coreData: CoreData) -> [HostMO] {
        var hosts: [HostMO] = []
        
        // Loop through all the known hosts
        for host in NetworkController.Host.allCases {
        
            // Fetch the stored host from coreData
            if let existingHost = fetchHost(withName: host.rawValue, coreData: coreData) {
                
                print("Existing Host")
                print(existingHost.name!)
                print(existingHost.url!)
                
                hosts.append(existingHost)
            }
                
            else {
                // Otherwise create a default host
                let defaultHost = createDefaultHost(for: host, coreData: coreData)
                hosts.append(defaultHost)
            }
        }
        
        return hosts.sorted {$0.name! < $1.name!}
        
       }
    
    static func fetchHost(withName hostName: String, coreData: CoreData) -> HostMO? {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "HostMO")
        let hostNamePredicate = NSPredicate(format: "name = %@", hostName)
        request.predicate = hostNamePredicate
        
        do {
            return try coreData.persistentContainer.viewContext.fetch(request).first as? HostMO
        }
            
        catch {
            fatalError("Error fetching HostMO")
        }
    }
    
    static func createDefaultHost(for host: NetworkController.Host, coreData: CoreData) -> HostMO {
        // Create default host from the PList
        
        let newHost = HostMO(context: coreData.persistentContainer.viewContext)
        newHost.name = host.rawValue
        newHost.url = Bundle.main.defaultURL(for: host )
        
        coreData.save(context: coreData.persistentContainer.viewContext)
        
        return newHost
    }
    
    func delete(coreData: CoreData) {
        coreData.persistentContainer.viewContext.delete(self)
    }
    
    enum Status: String {
        case online = "Online"
        case offline = "Offline"
        case connecting = "Connecting"
        
        var iconColour: String {
            switch self {
                
            case .online:
                return "6FF777"
            case .offline:
                return "F76F6F"
            case .connecting:
                return "F7BE6F"
            }
        }
    }
}
