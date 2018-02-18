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
    @IBOutlet weak var channelNameLbl: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        menuBtn.addTarget(self.revealViewController(), action: #selector(SWRevealViewController.revealToggle(_:)), for: .touchUpInside) //#selector is method that we get from another file, target is the revealviewcontroller, .touchupinside is the ui controller event
        
        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer()) //this is to slide the Rear VC to ChatVC by dragging your finger across screen...it came with the SWReveal Code
        self.view.addGestureRecognizer(self.revealViewController().tapGestureRecognizer()) //this is to open the  ChatVC by tapping on it from the RearVC
        
        NotificationCenter.default.addObserver(self, selector: #selector(ChatVC.userDataDidChange(_:)), name: NOTIFICATION_USER_DATA_DID_CHANGE, object: nil) //adding an observer
        NotificationCenter.default.addObserver(self, selector: #selector(ChatVC.channelSelected(_:)), name: NOTIFICATION_CHANNEL_SELECTED, object: nil) //observer, call the channelSelected function
    
        if AuthService.instance.isLoggedIn { //this is a check in the system
            AuthService.instance.findUserByEmail(completion: { (success) in
                NotificationCenter.default.post(name: NOTIFICATION_USER_DATA_DID_CHANGE, object: nil) //if loggedin is true, we will send a notification to everyone
            })
        }
    }
    
    @objc func userDataDidChange(_ notif: Notification) { //if notification is posted and we receive it, we will call this function as stated above
        if AuthService.instance.isLoggedIn {
            onLoginGetMessages()
        } else {
            channelNameLbl.text = "Please log in" //if were not logged in, itll say please log in
        }
    }
    
    @objc func channelSelected(_ notif: Notification) {
        updateWithChannel() //call the function
    }
    
    func updateWithChannel() { //to update the title of the view according to the channel we selected
        let channelName = MessageService.instance.selectedChannel?.channelTitle ?? "" //set the channelName, if it can't unwrap, set the channelName to an empty string.
        channelNameLbl.text = "#\(channelName)" //to change the text of the Lbl, set it to the channelName so it can update
        getMessages() //call the function 
    }
    
    func onLoginGetMessages() { //to get messages once were logged in 
        MessageService.instance.findAllChannel { (success) in //this will find all channels once we log in, so we can see them
            if success{
                if MessageService.instance.channels.count > 0 { //this is to check if there are channels, atleast 1. if there isnt, theres no point in calling this function
                    MessageService.instance.selectedChannel = MessageService.instance.channels[0] //this is if you re-enter the app, this will set the selected channel, as the first channel in the tableView
                    self.updateWithChannel() //update channel title
                } else {
                    self.channelNameLbl.text = "No channels yet!" //if theres no channel, this will set a new title to the channel of the view
                }
            }
        }
    }
    
    func getMessages() {
        guard let channelId = MessageService.instance.selectedChannel?.id else { return } //to unwrap the channel id. this is what we need to call messages
        MessageService.instance.findAllMessagesForChannel(channelId: channelId) { (success) in
            
        }
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
}
