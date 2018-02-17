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
    
    func clearChannels() {
        channels.removeAll() //to clear the channels once we log out
    }
    
    
}
