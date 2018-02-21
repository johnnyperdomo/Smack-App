//
//  MessageCell.swift
//  Smack-App
//
//  Created by Johnny Perdomo on 2/19/18.
//  Copyright © 2018 Johnny Perdomo. All rights reserved.
//

import UIKit

class MessageCell: UITableViewCell {

    
    //Outlets
    
    @IBOutlet weak var userImg: CircleImage!
    @IBOutlet weak var userNameLbl: UILabel!
    @IBOutlet weak var timeStampLbl: UILabel!
    @IBOutlet weak var messageBodyLbl: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    
    func configureCell(message: Message) { //to configure the messages to the cell
        messageBodyLbl.text = message.message //all the components of the cell information, inherited from the "Message" file class.
        userNameLbl.text = message.userName
        userImg.image = UIImage(named: message.userAvatar)
        userImg.backgroundColor = UserDataService.instance.returnUIColor(components: message.userAvatarColor)
        
        // 2017-21-13T21:49:25.590Z //we wanna remove the milliseconds that apple gives
        guard var isoDate = message.timeStamp else { return } //unwrap our date
        let end = isoDate.index(isoDate.endIndex, offsetBy: -5) //start at the end, then remove the last 5
        isoDate = isoDate.substring(to: end)
        
        let isoFormatter = ISO8601DateFormatter() //this is ios date formatter built in by apple
        let chatDate = isoFormatter.date(from: isoDate.appending("Z")) // now we have an actual data that looks like 2017-21-13T21:49:25Z
        
        let newFormatter = DateFormatter()
        newFormatter.dateFormat = "MMM d, h:mm a" //month, day, hour, minute, am/pm
        
        if let finalDate = chatDate {
            let finalDate = newFormatter.string(from: finalDate) //converting from a date to a string, makes it more readable to the user
            timeStampLbl.text = finalDate //send the timestamplbl
        }
    }

}
