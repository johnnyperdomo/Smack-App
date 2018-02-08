//
//  ChatVC.swift
//  Smack-App
//
//  Created by Johnny Perdomo on 1/13/18.
//  Copyright © 2018 Johnny Perdomo. All rights reserved.
//

//This is for the chat VC  
import UIKit

class ChatVC: UIViewController {

    @IBOutlet weak var menuBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        menuBtn.addTarget(self.revealViewController(), action: #selector(SWRevealViewController.revealToggle(_:)), for: .touchUpInside) //#selector is method that we get from another file, target is the revealviewcontroller, .touchupinside is the ui controller event
        
        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer()) //this is to slide the Rear VC to ChatVC by dragging your finger across screen...it came with the SWReveal Code
        self.view.addGestureRecognizer(self.revealViewController().tapGestureRecognizer()) //this is to open the  ChatVC by tapping on it from the RearVC
    
        if AuthService.instance.isLoggedIn { //this is a check in the system
            AuthService.instance.findUserByEmail(completion: { (success) in
                NotificationCenter.default.post(name: NOTIFICATION_USER_DATA_DID_CHANGE, object: nil) //if loggedin is true, we will send a notification to everyone
            })
        }
    }
}
