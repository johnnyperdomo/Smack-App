//
//  UserDataService.swift
//  Smack-App
//
//  Created by Johnny Perdomo on 1/22/18.
//  Copyright © 2018 Johnny Perdomo. All rights reserved.
//

//this file is to save the data/ all this information

import Foundation

class UserDataService {
    
    static let instance = UserDataService() //singleton, so there can only be instance used at any given moment
    
    public private(set) var id = "" //public, other files are able to see this, private(set) doesn't let the other files modify the value of the id
    public private(set) var avatarColor = ""
    public private(set) var avatarName = ""
    public private(set) var email = ""
    public private(set) var name = ""
    
    
    func setUserData(id: String, avatarColor: String, avatarName: String, email: String, name: String) { //a funciton to set the values from outside the file, with the AuthService
        self.id = id
        self.avatarColor = avatarColor
        self.avatarName = avatarName
        self.email = email
        self.name = name
    }
    
    func setAvatarName(avatarName: String) { //to update the avatarName later
        self.avatarName = avatarName
    }
    
}
