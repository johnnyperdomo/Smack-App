//
//  AuthService.swift
//  Smack-App
//
//  Created by Johnny Perdomo on 1/18/18.
//  Copyright © 2018 Johnny Perdomo. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

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
        
       
        let body: [String: Any] = [
            "email": lowerCaseEmail,
            "password": password
        ]
        
        Alamofire.request(URL_REGISTER, method: .post, parameters: body, encoding: JSONEncoding.default, headers: HEADER).responseString { (response) in //the webrequest
            
            if response.result.error == nil { //if everything works correctly
                completion(true) //this is where you use the completion handler
            } else {
                completion(false)
                debugPrint(response.result.error as Any)
            }
        }
        
    }
    
 //login function
    
    func loginUser(email: String, password: String, completion: @escaping CompletionHandler) {
        
        let lowerCaseEmail = email.lowercased() //lowercased is to let the user just type in the email in all lowercase letters

        let body: [String: Any] = [
            "email": lowerCaseEmail,
            "password": password
        ]
        
        Alamofire.request(URL_LOGIN, method: .post, parameters: body, encoding: JSONEncoding.default, headers: HEADER).responseJSON {
            (response) in
            
             if response.result.error == nil { //json parsing, traditional way
//                    if let json = response.result.value as?
//                        Dictionary<String, Any>  {
//                        if let email  = json["user"] as? String {
//                            self.userEmail = email
//                        }
//                        if let token = json["token"] as? String {
//                            self.authToken = token
//                        }
//                    }
            //Translating into JSON is really messy, Use "SwiftyJSON" instead.
            guard let data = response.data else { return }
            
            do { //you can use a do-catch block to handle the errors in JSON
                let json = try JSON(data: data)
                self.userEmail = json["user"].stringValue //using .stringValue safely unwraps it for you, or sets it to an empty string
                self.authToken = json["token"].stringValue
                self.isLoggedIn = true
            } catch {
                debugPrint(error)
            }
            
            
            completion(true)
            } else {
                completion(false)
                debugPrint(response.result.error as Any)
            }
        }
    }
  
    //add user function
    
    func createUser(name: String, email: String, avatarName: String, avatarColor: String, completion: @escaping CompletionHandler) {
        
        let lowerCaseEmail = email.lowercased()
        
        let body: [String: Any] = [
            "name": name,
            "email": lowerCaseEmail,
            "avatarName": avatarName,
            "avatarColor": avatarColor
            
            
        ]
        
        
        Alamofire.request(URL_USER_ADD, method: .post, parameters: body, encoding: JSONEncoding.default, headers: BEARER_HEADER).responseJSON { (response) in
            
            if response.result.error == nil {
                guard let data = response.data else { return }
                self.setUserInfo(data: data)
                completion(true)
                
            } else {
                completion(false)
                debugPrint(response.result.error as Any)
            }
        }
    }
    
    
 
    func findUserByEmail(completion: @escaping CompletionHandler) { //this is a function we can use to find user info and stay logged into our app.
        
        Alamofire.request("\(URL_USER_BY_EMAIL)\(userEmail)", method: .get, parameters: nil, encoding: JSONEncoding.default, headers: BEARER_HEADER).responseJSON { (response) in
            
            if response.result.error == nil {
                guard let data = response.data else { return }
                self.setUserInfo(data: data)
                completion(true)
            } else {
                completion(false)
                debugPrint(response.result.error as Any)
        }
    }
}

    func setUserInfo(data:Data) {
        do {
            let json = try JSON(data: data)
            let id = json["_id"].stringValue
            let avatarColor = json["avatarColor"].stringValue
            let avatarName = json["avatarName"].stringValue
            let email = json["email"].stringValue
            let name = json["name"].stringValue
            
            UserDataService.instance.setUserData(id: id, avatarColor: avatarColor, avatarName: avatarName, email: email, name: name) //here youre using the setUserData func we made in UserDataService.swift
        } catch {
            debugPrint(error)
        }
    }
}
