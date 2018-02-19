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
    }

}
