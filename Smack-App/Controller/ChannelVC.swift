//
//  ChannelVC.swift
//  Smack-App
//
//  Created by Johnny Perdomo on 1/13/18.
//  Copyright © 2018 Johnny Perdomo. All rights reserved.
//

//this is for the channel VC that slides out
import UIKit

class ChannelVC: UIViewController {
    
    @IBOutlet weak var loginBtn: UIButton!
    @IBOutlet weak var userImg: CircleImage!
    @IBAction func prepareForUnwind(segue: UIStoryboardSegue) {}
    

    override func viewDidLoad() {
        super.viewDidLoad()
 
        self.revealViewController().rearViewRevealWidth = self.view.frame.size.width - 60 //this is the width of the reveal view when its open..../{the rear view should take all of the screen size, except 60 points}
        
        NotificationCenter.default.addObserver(self, selector: #selector(ChannelVC.userDataDidChange(_:)), name: NOTIFICATION_USER_DATA_DID_CHANGE, object: nil) //this observes whenever the notification is posted
    }
    
    @IBAction func loginBtnPressed(_ sender: Any) {
        if AuthService.instance.isLoggedIn { //if logged in, show the profile page when clicking on button
            let profile = ProfileVC() //this is to present the profileVC since its a xib file, but not on story board
            profile.modalPresentationStyle = .custom
            present(profile, animated: true, completion: nil)
            
        } else {
            performSegue(withIdentifier: TO_LOGIN, sender: nil) //if not logged in, when Btn is pressed, go to login page
        }
    }
    
     @objc func userDataDidChange(_ notification: Notification) { //if notification is posted and we receive it, we will call this function as stated above
        if AuthService.instance.isLoggedIn { //if we logged in successfully it should show up in the channel vc
            loginBtn.setTitle(UserDataService.instance.name, for: .normal) // it should set our name
            userImg.image = UIImage(named: UserDataService.instance.avatarName) //it should show what avatar we picked
            userImg.backgroundColor = UserDataService.instance.returnUIColor(components: UserDataService.instance.avatarColor)
        } else { //if we didnt login successfully
            loginBtn.setTitle("Login", for: .normal) //set the title to "Login"
            userImg.image = UIImage(named: "menuProfileIcon") //sets a default image
            userImg.backgroundColor = UIColor.clear //and the background color is clear
        }
    }
    
}
