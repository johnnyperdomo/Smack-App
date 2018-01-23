//
//  AvatarCell.swift
//  Smack-App
//
//  Created by Johnny Perdomo on 1/22/18.
//  Copyright © 2018 Johnny Perdomo. All rights reserved.
//

import UIKit

class AvatarCell: UICollectionViewCell {
    
    @IBOutlet weak var avatarImg: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setUpView() 
    }
    
    
    
    func setUpView() { //for the view of the Avatar Img cells
        self.layer.backgroundColor = UIColor.lightGray.cgColor //background color
        self.layer.cornerRadius = 10 //cornerRadius
        self.clipsToBounds = true //so that Img doesn't cut out of the cell
    }
}
