//
//  Constants.swift
//  Smack-App
//
//  Created by Johnny Perdomo on 1/15/18.
//  Copyright © 2018 Johnny Perdomo. All rights reserved.
//

import Foundation

typealias CompletionHandler = (_ Success: Bool) -> () //type alias is renaming a type.

//URL Constants
let BASE_URL = "https://chatexample1.herokuapp.com/v1/" //this is the url to where the webrequest is being sent to. this is the url for where our app is being hosted online
let URL_REGISTER = "\(BASE_URL)account/register" //url for specific api location, so api what to do with this information
let URL_LOGIN = "\(BASE_URL)account/login"
let URL_USER_ADD = "\(BASE_URL)user/add"

//segues
let TO_LOGIN = "toLogin" //this sets a constant to the segue we need for the LoginVC from the ChannelVC
let TO_CREATE_ACCOUNT = "toCreateAccount" //constant for the segue from loginvc to CreateAccountVC
let UNWIND_TO_CHANNEL = "unwindToChannelVC" //to unwind from CreateAccountVC to ChannelVC
let TO_AVATAR_PICKER = "toAvatarPicker"

//User defaults
//these are things that will stay active even after a user closes the app
let TOKEN_KEY = "token"
let LOGGED_IN_KEY = "loggedIn"
let USER_EMAIL = "userEmail" 

//headers

let HEADER = [
    "Content-Type": "application/json; charset = utf-8" //web requests usually need a header, this is what it consists of
]

