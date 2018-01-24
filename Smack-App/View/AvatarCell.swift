//
//  AvatarCell.swift
//  Smack-App
//
//  Created by Johnny Perdomo on 1/22/18.
//  Copyright © 2018 Johnny Perdomo. All rights reserved.
//

import UIKit

enum AvatarType { //this enum is the two options between dark or light images. allows you to choose which one.
    case dark
    case light
}

class AvatarCell: UICollectionViewCell {
    
    @IBOutlet weak var avatarImg: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setUpView() 
    }
    
    
    func configureCell(index: Int, type: AvatarType) {
        if type == AvatarType.dark { //this uses the case dark from the enum we made
            avatarImg.image = UIImage(named: "dark\(index)")
            self.layer.backgroundColor = UIColor.lightGray.cgColor //if this is dark image, background color is lightgray
        } else {
            avatarImg.image = UIImage(named: "light\(index)")
            self.layer.backgroundColor = UIColor.gray.cgColor //if this is light image, background color is gray
            
        }
    }
    
    
    func setUpView() { //for the view of the Avatar Img cells
        self.layer.backgroundColor = UIColor.lightGray.cgColor //background color
        self.layer.cornerRadius = 10 //cornerRadius
        self.clipsToBounds = true //so that Img doesn't cut out of the cell
    }
}
