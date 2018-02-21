//
//  ChatVC.swift
//  Smack-App
//
//  Created by Johnny Perdomo on 1/13/18.
//  Copyright © 2018 Johnny Perdomo. All rights reserved.
//

//This is for the chat VC  
import UIKit

class ChatVC: UIViewController, UITableViewDelegate, UITableViewDataSource {

    //Outlets
    @IBOutlet weak var menuBtn: UIButton!
    @IBOutlet weak var channelNameLbl: UILabel!
    @IBOutlet weak var messageTxtBox: UITextField!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var sendBtn: UIButton!
    @IBOutlet weak var typingUsersLbl: UILabel!
    
    
    //Variables
    var isTyping = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self //conforming protocols
        tableView.dataSource = self
        
        tableView.estimatedRowHeight = 80 //an estimated row height for the messages
        tableView.rowHeight = UITableViewAutomaticDimension //will give us the correct height
        
        sendBtn.isHidden = true //sendBtn is hidden if not typing
        
        view.bindToKeyboard() //this is the function that allows you to bind your view to the keyboard
        let tap = UITapGestureRecognizer(target: self, action: #selector(ChatVC.handleTap)) //to dismiss the keyboard that we're typing on
        view.addGestureRecognizer(tap) //to add it
        
        menuBtn.addTarget(self.revealViewController(), action: #selector(SWRevealViewController.revealToggle(_:)), for: .touchUpInside) //#selector is method that we get from another file, target is the revealviewcontroller, .touchupinside is the ui controller event
        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer()) //this is to slide the Rear VC to ChatVC by dragging your finger across screen...it came with the SWReveal Code
        self.view.addGestureRecognizer(self.revealViewController().tapGestureRecognizer()) //this is to open the  ChatVC by tapping on it from the RearVC
        
        NotificationCenter.default.addObserver(self, selector: #selector(ChatVC.userDataDidChange(_:)), name: NOTIFICATION_USER_DATA_DID_CHANGE, object: nil) //adding an observer
        NotificationCenter.default.addObserver(self, selector: #selector(ChatVC.channelSelected(_:)), name: NOTIFICATION_CHANNEL_SELECTED, object: nil) //observer, call the channelSelected function
    
        SocketService.instance.getChatMessage { (newMessage) in //to run the function to get the chat message
            if newMessage.channelId == MessageService.instance.selectedChannel?.id && AuthService.instance.isLoggedIn { //if message is in the same channel and the user is logged in
                MessageService.instance.messages.append(newMessage) //add message
                self.tableView.reloadData()
                if MessageService.instance.messages.count > 0  { //to check whether we have messages and scrolls down to the latest one
                    let endIndex = IndexPath(row: MessageService.instance.messages.count - 1, section: 0) //index for the row
                    self.tableView.scrollToRow(at: endIndex, at: .bottom, animated: false) //scrolls to bottom, latest message
                }
            }
        }
        
        
        SocketService.instance.getTypingUsers { (typingUsers) in //to check whether someone is typing
            guard let channelId = MessageService.instance.selectedChannel?.id else { return } //to check whether the user is on the right channel
            var names = "" //name of the user
            var numberOfTypers = 0
            
            for (typingUser, channel) in typingUsers {
                if typingUser != UserDataService.instance.name && channel == channelId { //if not us
                    if names == "" { //if there's no one in the dictionary, or its their first time
                        names = typingUser
                    } else {
                        names = "\(names), \(typingUser)" //if more than one person is typing
                    }
                    numberOfTypers += 1
                }
            }
            
            if numberOfTypers > 0 && AuthService.instance.isLoggedIn == true { //if we're logged in, and there are atleast 1 typer
                var verb = "is" //for 1 person typing
                if numberOfTypers > 1 {
                    verb = "are" //for multiple people typing
                }
                self.typingUsersLbl.text = "\(names) \(verb) typing a message..." //will show user/users typing
            } else {
                self.typingUsersLbl.text = "" //if not, it'll be empty
            }
        }
        
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
            tableView.reloadData()
        }
    }
    
    @objc func channelSelected(_ notif: Notification) {
        updateWithChannel() //call the function
    }
    
    @objc func handleTap() { //to dismiss the keyboard when were done typing
        view.endEditing(true)
    }
    
    func updateWithChannel() { //to update the title of the view according to the channel we selected
        let channelName = MessageService.instance.selectedChannel?.channelTitle ?? "" //set the channelName, if it can't unwrap, set the channelName to an empty string.
        channelNameLbl.text = "#\(channelName)" //to change the text of the Lbl, set it to the channelName so it can update
        getMessages() //call the function 
    }
    
    
    
    //actions
    
    @IBAction func messageBoxEditing(_ sender: Any) { //to show or hide send btn based on whether we are typing or not
        guard let channelId = MessageService.instance.selectedChannel?.id else { return }
        if messageTxtBox.text == "" {
            isTyping = false
            sendBtn.isHidden = true
            SocketService.instance.socket.emit("stopType", UserDataService.instance.name, channelId)
        } else {
            if isTyping == false {
                sendBtn.isHidden = false
                SocketService.instance.socket.emit("startType", UserDataService.instance.name, channelId)
            }
            
            isTyping = true
        }
    }
    
    
    @IBAction func sendMessagePressed(_ sender: Any) {
        if AuthService.instance.isLoggedIn { //to check if we're logged in
            guard let channelId = MessageService.instance.selectedChannel?.id else { return } //to ensure what channel we're on
            guard let message = messageTxtBox.text else { return } //the message itself
            
            SocketService.instance.addMessage(messageBody: message, userId: UserDataService.instance.id, ChannelId: channelId, completion: { (success) in
                if success {
                    self.messageTxtBox.text = "" //to make the txtbox blank again
                    self.messageTxtBox.resignFirstResponder() //to dismiss keyboard
                    SocketService.instance.socket.emit("stopType", UserDataService.instance.name, channelId) //if sendmessage is pressed, stop typing
                    self.sendBtn.isHidden = true //will hide sendbtn when we click on it 
                }
            })
        }
    }
    
    //
    
    
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
            if success {
                self.tableView.reloadData() //if we're successful, we will get messages, reload data, and see the messages
            }
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell { //function for messages in tableview cell
        if let cell = tableView.dequeueReusableCell(withIdentifier: "messageCell", for: indexPath) as? MessageCell { ////'as? MessageCell' is the class name for the Cell view
            let message = MessageService.instance.messages[indexPath.row] //grab the message that corresponds
            cell.configureCell(message: message)
            return cell
        } else {
            return UITableViewCell()
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int { //number of sections in our table view Cell
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { //this is for the amount of rows in our tableView
        return MessageService.instance.messages.count //the amount of rows corresponds to the number of messages we have
    }
    
    
    
    
}
