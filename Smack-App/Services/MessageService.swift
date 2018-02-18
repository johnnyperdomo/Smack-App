//
//  MessageService.swift
//  Smack-App
//
//  Created by Johnny Perdomo on 2/8/18.
//  Copyright © 2018 Johnny Perdomo. All rights reserved.
//

//this is to control the messaging aspect of app, allows you to storage messages/channels send, and retrieve messages
import Foundation
import Alamofire
import SwiftyJSON


class MessageService {
    
    static let instance = MessageService() //singleton
    
    var channels = [Channel]() //this gets the objects from the "Channels" file, found in the Model group
    var messages = [Message]() //when we create a new message, we'll append to an array of messages
    var selectedChannel : Channel? //optional bcuz if were not logged in, we wont have a selected channel
    
    func findAllChannel(completion: @escaping CompletionHandler) { //to find channels
        Alamofire.request(URL_GET_CHANNELS, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: BEARER_HEADER).responseJSON { (response) in
            
            if response.result.error == nil {
                guard let data = response.data else {return}
                
                if let json = try! JSON(data: data).array { //this gives us an array of json objects
                    for item in json { //loops the objects until it finds something
                        let name = item["name"].stringValue //looking for an item with the word "name"
                        let channelDescription = item["description"].stringValue //description of the channel
                        let id = item["_id"].stringValue //id of the channel
                        let channel = Channel(channelTitle: name, channelDescription: channelDescription, id: id) //this initializes a new channel object,
                        self.channels.append(channel) //then add this new channel into "channels" array
                    }
                    NotificationCenter.default.post(name: NOTIFICATION_CHANNELS_LOADED, object: nil) //sends a notif that channels are ready to be loaded
                    completion(true)
                }
                
                print(self.channels)

            } else {
                completion(false)
                debugPrint(response.result.error as Any)
            }
            
        }
    }
    
    func findAllMessagesForChannel(channelId: String, completion: @escaping CompletionHandler) { //to find messages for the channel we choose
        Alamofire.request("\(URL_GET_MESSAGES)\(channelId)", method: .get, parameters: nil, encoding: JSONEncoding.default, headers: BEARER_HEADER).responseJSON { (response) in
            
            if response.result.error == nil {
                self.clearMessages() //to clear messages from the channel once we choose different channels
                
                guard let data = response.data else { return } //json parsing to get messages from API
                if let json = try! JSON(data: data).array {
                    for item in json { //creating a for loop to go through all the message objects and check for all the things it needs and extracts the properties for each object
                        let messageBody = item["messageBody"].stringValue //this is the object its extracting the properties from.
                        let channelId = item["channelId"].stringValue //this will loop through all these objects until its done
                        let id = item["_id"].stringValue
                        let userName = item["userName"].stringValue
                        let userAvatar = item["userAvatar"].stringValue
                        let userAvatarColor = item["userAvatarColor"].stringValue
                        let timeStamp = item["timeStamp"].stringValue
                        
                        let message = Message(message: messageBody, userName: userName, channelId: channelId, userAvatar: userAvatar, userAvatarColor: userAvatarColor, id: id, timeStamp: timeStamp) //creating a new message object
                        self.messages.append(message) //this adds it to the message Array
                        
                    }
                    print(self.messages)
                    completion(true)
                    
                }
                
            } else {
                debugPrint(response.result.error as Any)
                completion(false)
            }
            
        }
        
    }
    
    func clearMessages() { //to clear messages
        messages.removeAll()
    }
    
    
    func clearChannels() {
        channels.removeAll() //to clear the channels once we log out
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
}
