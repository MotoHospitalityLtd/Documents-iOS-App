//
//  AuthController.swift
//  Forecourt Documents
//
//  Created by Edwards, Mike on 16/07/2021.
//

import Foundation
import CoreData

class AuthController {
    
    //# MARK: - Data
    let coreData: CoreData
    
    //# MARK: - Controllers:
    let networkController: NetworkController
    
    //# MARK: - Initialisers
    init(coreData: CoreData, networkController: NetworkController) {
        self.coreData = coreData
        self.networkController = networkController
    }
    
    internal func authenticateUser(userCredential: UserCredential, completion: @escaping (LoginResponse) -> Void) {
        
        // Attempt to authenticate the user locally (expires after 1 hour).
        if let authenticatedUser = authenticateLocally(userCredential: userCredential) {
            print("Authenticated Locally")
        
            
            // Need to fetch the authenticated user.
            if networkController.authenticatedUser == authenticatedUser {
                print("Same User Logging in")
                
                completion(.returningUser)
                
                // Fetch existing user if one exists
                // Check if it matches given credentials
                // If it does and it is not expired, login
                // if it does not match
                    // network login
                        // success?
                            // remove old user
                            // create new user
                        // fail
                            // forward error.
                
                // Success
                    // Returning User (Was the last user that logged in)
                        // Remove login screen
                    // NewLogin
                        // Remove login screen
                        // Set root screen
                // Error
                    // Authentication Error
                    // Too Many Logins
                    // No Network
                    // Other Error
            }
            
            else {
                print("Different User Logging in")
                // Set Current User on Network Controller
                networkController.authenticatedUser = authenticatedUser
                completion(.newLogin)
            }
        }
        
        // Attempt to authenticate the user over the network.
        else {
            print("Authenticate Remotely")
            
            authenticateRemotely(userCredential: userCredential) { response in
                switch response {
                
                case .newLogin:
                    completion(.newLogin)
                    print("Successful remote authentication - New User")
                    
                case .returningUser:
                    completion(.returningUser)
                    print("Successful remote authentication - Returning User")
                case .error(let httpError):
                    print("Error remote authentication")
                    completion(LoginResponse.error(httpError))
                }
            }
        }
    }
    
    func createUser(userCredential: UserCredential) -> UserMO {
        let newUser = UserMO(context: coreData.persistentContainer.viewContext)
        
        newUser.employeeNumber = userCredential.encryptedEmployeeNumber
        newUser.dateOfBirth = userCredential.encryptedDateOfBirth

        // Set the expiry to be 1 hour ahead from the current system date.
        newUser.setLoginExpiry()
        
        coreData.save(context: coreData.persistentContainer.viewContext)
        
        return newUser
    }
    
    private func authenticateLocally(userCredential: UserCredential) -> UserMO? {
    
        // Fetch the user with the given details.
        guard let existingUser = fetchUser(withUserCredential: userCredential) else {return nil}
        
        // Check if the users ability to login locally has expired.
        if existingUser.loginExpired {
            return nil
        }
        
        else {
            return existingUser
        }
    }
    
    private func authenticateRemotely(userCredential: UserCredential, completion: @escaping (LoginResponse) -> Void) {
        
        // Encode the user credential
        let data = try? JSONEncoder().encode(userCredential)
        
        self.networkController.post(urlPath: "/api/auth", data: data) { response in
            DispatchQueue.main.async {
                switch response {
                case .success(let data):
                    print("Success")
                    
                    do {
                        let decodedData = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as! [String: AnyObject]
                        let authToken = decodedData["token"] as! String
                        
                        // Update or create an existing user and set the current authenticated user
                        
                        // If a local authorised user exists then update their details
                        if let returningUser = self.fetchUser(withUserCredential: userCredential) {
                            print("Logged in via network, user already exists")
                            
                            returningUser.authToken = authToken
                            
                            // Set the expiry to be 1 hour ahead from the current system date.
                            returningUser.setLoginExpiry()
                            
                            self.coreData.save(context: self.coreData.persistentContainer.viewContext)
                            
                            self.networkController.authenticatedUser = returningUser
                            
                            completion(.returningUser)
                        }
                        
                        // Else remove all users and create a new user setting their token
                        else {
                            print("Logged in via network, new user")
                            self.removeUsers()
                            
                            let newUser = self.createUser(userCredential: userCredential)
                            newUser.authToken = authToken
                            
                            self.coreData.save(context: self.coreData.persistentContainer.viewContext)
                            
                            self.networkController.authenticatedUser = newUser
                            
                            completion(.newLogin)
                        }
                    }
                        
                    catch {
                        print("catch error: \(error)")
                    }
                    
                case .error(let httpError):
                   completion(.error(httpError))
                }
            }
        }
    }
    
    internal func removeUsers() {
        let users = fetchUsers()
        
        for user in users {
            coreData.persistentContainer.viewContext.delete(user)
        }
        
        networkController.authenticatedUser = nil
        
        coreData.save(context: coreData.persistentContainer.viewContext)
    }
    
    private func fetchUser(withUserCredential credential: UserCredential) -> UserMO? {
        // Fetch a user that matches the given encrypted employee number and encrypted date of birth.
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "UserMO")
        
        let predicateEmployeeNumber = NSPredicate(format: "employeeNumber = %@", credential.encryptedEmployeeNumber)
        let predicateDateOfBirth = NSPredicate(format: "dateOfBirth = %@", credential.encryptedDateOfBirth)
        let predicate = NSCompoundPredicate.init(type: .and, subpredicates: [predicateEmployeeNumber, predicateDateOfBirth])
        
        request.predicate = predicate
        
        do {
            return try coreData.persistentContainer.viewContext.fetch(request).first as? UserMO
        }
            
        catch {
            fatalError("Error fetching user")
        }
    }

    private func fetchUsers() -> [UserMO] {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "UserMO")
        
        do {
            return try coreData.persistentContainer.viewContext.fetch(request) as! [UserMO]
        }
            
        catch {
            fatalError("Error fetching users")
        }
    }
    
    // Login
        // Does the employeeNumber already exists?
            // No - Network Login
            // Yes - Attempt local authentication - stored as hashed data.
    
        // Expired?
            // Yes - Force Network Login
       
            // No - Login Locally
        
        // Locally
            // Encrypt login details and if they match a stored user, login
          
        // Network
            // If login successful, create or update user
            // Set current user
    
    // if current user set, and the new login matches the current user, Pop the login screen.
    // If the users are different then start the app from the initial login screen.
    
    // Set current user
    
    // Logout
        // Remove current user
        // Start app from initial login screen.
    
    // Store User
        // Encrypt
        // Save to Core D
    
    enum LoginResponse {
        case returningUser
        case newLogin
        case error(NetworkController.HttpError)
    }
    
}
