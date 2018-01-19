//
//  AuthService.swift
//  Smack-App
//
//  Created by Johnny Perdomo on 1/18/18.
//  Copyright © 2018 Johnny Perdomo. All rights reserved.
//

import Foundation
import Alamofire

class AuthService {
    
    static let instance = AuthService() //singleton, accessed globally. only one instance of it at a time
    
    let defaults = UserDefaults.standard //most simple way of saving data in your app
    
    var isLoggedIn : Bool { //a way to display whether the user is logged in or not
        get {
            return defaults.bool(forKey: LOGGED_IN_KEY) //will return the "loggedIn constant"
        }
        set {
            defaults.set(newValue, forKey: LOGGED_IN_KEY)
        }
    }
    
    var authToken: String { //for the authorization token
        get {
            return defaults.value(forKey: TOKEN_KEY) as! String // defaults.value returns an optional (any?) so you gotta cast it as a string
        }
        set {
            defaults.set(newValue, forKey: TOKEN_KEY) //newValue means whatever its whatever we set the value to it
        }
    }
    
    var userEmail: String { //to see the email once youre logged in
        get {
            return defaults.value(forKey: USER_EMAIL) as! String
        }
        set {
            defaults.set(newValue, forKey: USER_EMAIL) //newValue means whatever its whatever we set the value to it
        }
    }
    
    //to create a register user function. Make a web request -> use alamofire
    
    func registerUser(email: String, password: String, completion: @escaping CompletionHandler) { //to register a user, you need both an email and a password
        
        //web requests need a header, and a body
        
        let lowerCaseEmail = email.lowercased() //lowercased is to let the user just type in the email in all lowercase letters
        
        let header = [
            "Content-Type": "application/json; charset = utf-8" //web requests usually need a header, this is what it consists of
        ]
        
        let body: [String: Any] = [
            "email": lowerCaseEmail,
            "password": password
        ]
        
        Alamofire.request(URL_REGISTER, method: .post, parameters: body, encoding: JSONEncoding.default, headers: header).responseString { (response) in //the webrequest
            
            if response.result.error == nil { //if everything works correctly
                completion(true) //this is where you use the completion handler
            } else {
                completion(false)
                debugPrint(response.result.error as Any)
            }
        }
        
        
        
        
        
    }
    
  
    
    
    
    
}


