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
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    //variables
    var avatarName = "profileDefault" //default image if no one picks an avatar
    var avatarColor = "[0.5, 0.5, 0.5, 1]" //default light grey color if no one chooses
    var bgColor : UIColor? //variable for generated BGColor
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()  //this is the function for the color of the placeHolder text
        
    }
    
    override func viewDidAppear(_ animated: Bool) { //if name is not empty, it adds the avatar image
        if UserDataService.instance.avatarName != "" {
            userImg.image = UIImage(named: UserDataService.instance.avatarName)
            avatarName = UserDataService.instance.avatarName //makes the variable we made here for avatarName = the avatarName used in the dataservice
            if avatarName.contains("light") && bgColor == nil { //if you haven't selected a bgColor yet for the userImg and if you choose a "light" avatar, make the userImg bgColor lightgrey
                userImg.backgroundColor = UIColor.lightGray
            }
        }
    }
    
    @IBAction func createAccountPressed(_ sender: Any) {
        spinner.isHidden = false // wehn btn is pressed, show spinner
        spinner.startAnimating() //let the spinner spin
        guard let name = usernameTxt.text , usernameTxt.text != "" else { return }
        guard let email = emailTxt.text , emailTxt.text != "" else { return } //guard statements are another way of unwrapping optionals
        guard let password = passwordTxt.text , passwordTxt.text != "" else { return } //the .text is an optional, we have to unwrap it
        
        
        AuthService.instance.registerUser(email: email, password: password) { (success) in //we passed the values into the Authservice to register a user
            if success {
                AuthService.instance.loginUser(email: email, password: password, completion: { (success) in
                    if success {
                        AuthService.instance.createUser(name: name, email: email, avatarName: self.avatarName, avatarColor: self.avatarColor, completion: { (success) in
                            if success {
                                self.spinner.isHidden = true //if its successful, hide the spinner
                                self.spinner.stopAnimating() //if its successful, stop spinning
                                self.performSegue(withIdentifier: UNWIND_TO_CHANNEL, sender: nil)
                                NotificationCenter.default.post(name: NOTIFICATION_USER_DATA_DID_CHANGE, object: nil) //if successfully logged in or out, it sends us a notification and lets the user know
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
    
    
    @IBAction func pickBGColorPressed(_ sender: Any) { //rgb= red,green,blue
        let r = CGFloat(arc4random_uniform(255)) / 255 //to make a random number with the colors
        let g = CGFloat(arc4random_uniform(255)) / 255 //to make a random number with the colors
        let b = CGFloat(arc4random_uniform(255)) / 255 //to make a random number with the colors
        
        bgColor = UIColor(red: r, green: g, blue: b, alpha: 1) //alpha : 1, means the value is not transparent
        UIView.animate(withDuration: 0.2) { //this is to give animation to the changing of the bgColor
            self.userImg.backgroundColor = self.bgColor
        }
        

    }
    
    
    
    @IBAction func closePressed(_ sender: Any) {
        performSegue(withIdentifier: UNWIND_TO_CHANNEL, sender: nil) //when closeBtn is pressed, it takes you all the way back to the channel VC
    }
    
    func setupView() {
        spinner.isHidden = true //the spinner won't show
        usernameTxt.attributedPlaceholder = NSAttributedString(string: "username", attributes: [NSAttributedStringKey.foregroundColor: SMACK_PURPLE_PLACE_HOLDER])  //this is going to be for the color of the placeHolder text
        emailTxt.attributedPlaceholder = NSAttributedString(string: "email", attributes: [NSAttributedStringKey.foregroundColor: SMACK_PURPLE_PLACE_HOLDER])
        passwordTxt.attributedPlaceholder = NSAttributedString(string: "password", attributes: [NSAttributedStringKey.foregroundColor: SMACK_PURPLE_PLACE_HOLDER])
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(CreateAccountVC.handleTap)) //to tap the screen, keyboard will hide
        view.addGestureRecognizer(tap) //to add the gesture
    }
    
    @objc func handleTap() {
        view.endEditing(true) //if keyboard is open, and we tap the screen, the keyboard will disappear
    }
    
}
