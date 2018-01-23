//
//  CreateAccountVC.swift
//  Smack-App
//
//  Created by Johnny Perdomo on 1/15/18.
//  Copyright © 2018 Johnny Perdomo. All rights reserved.
//

import UIKit

class CreateAccountVC: UIViewController {

    //outlets
    @IBOutlet weak var usernameTxt: UITextField!
    @IBOutlet weak var emailTxt: UITextField!
    @IBOutlet weak var passwordTxt: UITextField!
    @IBOutlet weak var userImg: UIImageView!
    
    //variables
    var avatarName = "profileDefault" //default image if no one picks an avatar
    var avatarColor = "[0.5, 0.5, 0.5, 1]" //default light grey color if no one chooses
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func createAccountPressed(_ sender: Any) {
        guard let name = usernameTxt.text , usernameTxt.text != "" else { return }
        guard let email = emailTxt.text , emailTxt.text != "" else { return } //guard statements are another way of unwrapping optionals
        guard let password = passwordTxt.text , passwordTxt.text != "" else { return } //the .text is an optional, we have to unwrap it
        
        
        AuthService.instance.registerUser(email: email, password: password) { (success) in //we passed the values into the Authservice to register a user
            if success {
                AuthService.instance.loginUser(email: email, password: password, completion: { (success) in
                    if success {
                        AuthService.instance.createUser(name: name, email: email, avatarName: self.avatarName, avatarColor: self.avatarColor, completion: { (success) in
                            if success {
                                print(UserDataService.instance.name, UserDataService.instance.avatarName)
                                self.performSegue(withIdentifier: UNWIND_TO_CHANNEL, sender: nil)
                            }
                        })
                    }
                })
            }
        }
        
    }
    

    @IBAction func pickAvatarPressed(_ sender: Any) {
        performSegue(withIdentifier: TO_AVATAR_PICKER, sender: nil)
    }
    
    
    @IBAction func pickBGColorPressed(_ sender: Any) {
    }
    
    
    
    @IBAction func closePressed(_ sender: Any) {
        performSegue(withIdentifier: UNWIND_TO_CHANNEL, sender: nil) //when closeBtn is pressed, it takes you all the way back to the channel VC
    }
    
}
