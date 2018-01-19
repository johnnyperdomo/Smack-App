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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func createAccountPressed(_ sender: Any) {
        guard let email = emailTxt.text , emailTxt.text != "" else //guard statements are another way of unwrapping optionals
        { return }
        
        guard let password = passwordTxt.text , passwordTxt.text != "" else //the .text is an optional, we have to unwrap it
        { return }
        
        AuthService.instance.registerUser(email: email, password: password) { (success) in //we passed the values into the Authservice to register a user
            if success {
                print("registered user!")
            }
        }
    }
    

    @IBAction func pickAvatarPressed(_ sender: Any) {
    }
    
    
    @IBAction func pickBGColorPressed(_ sender: Any) {
    }
    
    
    
    @IBAction func closePressed(_ sender: Any) {
        performSegue(withIdentifier: UNWIND_TO_CHANNEL, sender: nil) //when closeBtn is pressed, it takes you all the way back to the channel VC
    }
    
}
