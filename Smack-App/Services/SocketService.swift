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
        socket.on("channelCreated") { (dataArray, ack) in //listens for a new chat message
            guard let channelName = dataArray[0] as? String else { return }
            guard let channelDescription = dataArray[1] as? String else { return }
            guard let channelId = dataArray[2] as? String else { return }
            
            let newChannel = Channel(channelTitle: channelName, channelDescription: channelDescription, id: channelId) //we added a new channel
            
            MessageService.instance.channels.append(newChannel) //this adds a new channel for us
            completion(true)
        }
    }
    
    
    
    
    
    
    
    
}