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
    
    func setAvatarName(avatarName: String) { //to update the avatarName 
        self.avatarName = avatarName
    }
    
    func returnUIColor(components: String) -> UIColor { //this function is to return a UIColor when we input a string value. for the bgColor generator
    //      "[0.3435435345435, 0.43534543534543, 0.435345435433352, 1]" //this are the rgb colors that are generated when you create the generate random bgcolor btn
        
        let scanner = Scanner(string: components) //Scanner scans a specific thing like "string values" and you can tell it what to do
        let skipped = CharacterSet(charactersIn: "[], ") //this skips whatever value you tell it to skip when its scanning... brackets, comma, and a space
        let comma =  CharacterSet(charactersIn: ",")//to tell it to stop at a specific character, this example being the comma, since the string of numbers for 1 color stops before the comma
        scanner.charactersToBeSkipped = skipped //this sets the value
        
        
        var r, g, b, a : NSString? //this created multiple variables on one line, as long as they're of the same type
        
        scanner.scanUpToCharacters(from: comma, into: &r) //gotta use the '&' because thats the way it is/ scans up to the comma, and saves the value into variable r
        scanner.scanUpToCharacters(from: comma, into: &g) //continues from where it left off, and scans the next set of numbers until comma into the g variable
        scanner.scanUpToCharacters(from: comma, into: &b) //b variable
        scanner.scanUpToCharacters(from: comma, into: &a)// a or alpha variable
        
        //since the variables are optional types, we have to unwrap them
        
        let defaultColor = UIColor.lightGray //this is just in case the variables don't unwrap successfully, we still need to return a UIColor because the function requires it 
        
        guard let rUnwrapped = r else { return defaultColor } //unwrap these variables, if they fail, it'll return our default color
        guard let gUnwrapped = g else { return defaultColor }
        guard let bUnwrapped = b else { return defaultColor }
        guard let aUnwrapped = a else { return defaultColor }
        
        //now we have to convert these strings into CGFloats because UIColor uses CGFloat, so we have to convert 'string' into a 'Double Value', then 'Double Value' into 'CGFloat'
        
        let rFloat = CGFloat(rUnwrapped.doubleValue) //converting these unrapped strings into a double, then into a CGFLoat
        let gFloat = CGFloat(gUnwrapped.doubleValue)
        let bFloat = CGFloat(bUnwrapped.doubleValue)
        let aFloat = CGFloat(aUnwrapped.doubleValue)
        
        let newUIColor = UIColor(red: rFloat, green: gFloat, blue: bFloat, alpha: aFloat) //now we have to initialize this
        
        return newUIColor
    }
    
    func logoutUser() { //this func sets all the information back to normal, and logs out user
        id = ""
        avatarName = ""
        avatarColor = ""
        email = ""
        name = ""
        AuthService.instance.isLoggedIn = false
        AuthService.instance.userEmail = ""
        AuthService.instance.authToken = ""
    }
    
    
    
    
    
    
    
    
    
    
}
