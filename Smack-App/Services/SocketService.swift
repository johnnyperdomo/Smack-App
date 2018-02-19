//
//  SocketService.swift
//  Smack-App
//
//  Created by Johnny Perdomo on 2/14/18.
//  Copyright © 2018 Johnny Perdomo. All rights reserved.
//

//service for our sockets
import UIKit
import SocketIO //for the socket service

class SocketService: NSObject { //nsobject is the base class for most objc objects. we want our swift object to be an objc object.

    
     static let instance = SocketService() //singleton
    
    override init() {
        super.init()
    }
    
    var socket : SocketIOClient = SocketIOClient(socketURL: URL(string: BASE_URL)!) //! to force unwrap
    
    func establishConnection() {
        socket.connect() //connects to the server
    }
    
    func closeConnection() {
        socket.disconnect() //disconnects from the server
        
    }
    
    func addChannel(channelName: String, channelDescription: String, completion: @escaping CompletionHandler) {
        socket.emit("newChannel", channelName, channelDescription) //this is to send information to Api
        completion(true)
    }
    
    func getChannel(completion: @escaping CompletionHandler) {
        socket.on("channelCreated") { (dataArray, ack) in //listens for a new channel
            guard let channelName = dataArray[0] as? String else { return }
            guard let channelDescription = dataArray[1] as? String else { return }
            guard let channelId = dataArray[2] as? String else { return }
            
            let newChannel = Channel(channelTitle: channelName, channelDescription: channelDescription, id: channelId) //we added a new channel
            
            MessageService.instance.channels.append(newChannel) //this adds a new channel for us
            completion(true)
        }
    }
    
    
    func addMessage(messageBody: String, userId: String, ChannelId: String, completion: @escaping CompletionHandler) { //to add a message, and including the personal ids it needs
        let user = UserDataService.instance //to make a shortcut
        socket.emit("newMessage", messageBody, userId, ChannelId, user.name, user.avatarName, user.avatarColor) //we send message to API
        completion(true)
    }
    
    func getChatMessage(completion: @escaping CompletionHandler) { //to get chat messages, listening to event
        socket.on("messageCreated") { (dataArray, ack) in //if we receive it, we get with it a data Array
            guard let msgBody = dataArray[0] as? String else { return } //parse through these values
            guard let channelId = dataArray[2] as? String else { return }
            guard let userName = dataArray[3] as? String else { return }
            guard let userAvatar = dataArray[4] as? String else { return }
            guard let userAvatarColor = dataArray[5] as? String else { return }
            guard let id = dataArray[6] as? String else { return }
            guard let timeStamp = dataArray[7] as? String else { return }
            
            if channelId == MessageService.instance.selectedChannel?.id && AuthService.instance.isLoggedIn { //to check whether we're logged in and if we're on the correct channel where the message is being sent to
                
                let newMessage = Message(message: msgBody, userName: userName, channelId: channelId, userAvatar: userAvatar, userAvatarColor: userAvatarColor, id: id, timeStamp: timeStamp)
                MessageService.instance.messages.append(newMessage) //append what we just created
                completion(true)
            } else {
                completion(false) //if it don't work, don't do anything
            }
        }
    }
    
    
    
    
    
}
