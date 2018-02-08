//
//  LoginVC.swift
//  Smack-App
//
//  Created by Johnny Perdomo on 1/15/18.
//  Copyright © 2018 Johnny Perdomo. All rights reserved.
//

import UIKit

class LoginVC: UIViewController {
    
    //Outlets
    @IBOutlet weak var emailTxt: UITextField!
    @IBOutlet weak var passwordTxt: UITextField!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpView()
    }

    
    @IBAction func loginPressed(_ sender: Any) { //when we hit the login button, we'll be able to access our data
        spinner.isHidden = false
        spinner.startAnimating()
        
        guard let email = emailTxt.text, emailTxt.text != "" else { return } //email
        guard let passWord = passwordTxt.text, passwordTxt.text != "" else { return } //password
        
        AuthService.instance.loginUser(email: email, password: passWord) { (success) in //login successful
            if success {
                AuthService.instance.findUserByEmail(completion: { (success) in //if successful, find our user data
                    if success {
                        NotificationCenter.default.post(name: NOTIFICATION_USER_DATA_DID_CHANGE, object: nil) //lets all the other channel know we logged in
                        self.spinner.isHidden = true
                        self.spinner.stopAnimating()
                        self.dismiss(animated: true, completion: nil)
                    }
                })
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func closePressed(_ sender: Any) {
        dismiss(animated: true, completion: nil) //this closes the login VC by clicking on the Close Button(x)
    }
    
    @IBAction func createAccountBtnPressed(_ sender: Any) {
        performSegue(withIdentifier: TO_CREATE_ACCOUNT, sender: nil) //when createAccountBtn is pressed, we go to the CreateAccountVC
    }
    
    func setUpView() {
        spinner.isHidden = true
        emailTxt.attributedPlaceholder = NSAttributedString(string: "email", attributes: [NSAttributedStringKey.foregroundColor: SMACK_PURPLE_PLACE_HOLDER])  //this is going to be for the color of the placeHolder text
        passwordTxt.attributedPlaceholder = NSAttributedString(string: "password", attributes: [NSAttributedStringKey.foregroundColor: SMACK_PURPLE_PLACE_HOLDER])
    }
    
}
