//
//  CircleImage.swift
//  Smack-App
//
//  Created by Johnny Perdomo on 1/24/18.
//  Copyright © 2018 Johnny Perdomo. All rights reserved.
//

import UIKit

@IBDesignable
class CircleImage: UIImageView {

    override func awakeFromNib() {
        setupView()
    }
    
    func setupView() {
        self.layer.cornerRadius = self.frame.width / 2 //this makes it a circle
        self.clipsToBounds = true
    }
    
    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        self.setupView()
    }
}
