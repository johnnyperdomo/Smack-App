//
//  RoundedButton.swift
//  Smack-App
//
//  Created by Johnny Perdomo on 1/18/18.
//  Copyright © 2018 Johnny Perdomo. All rights reserved.
//

import UIKit

@IBDesignable
class RoundedButton: UIButton { //to make the buttons round around the edges

    @IBInspectable var cornerRadius: CGFloat = 3.0{
        didSet {
            self.layer.cornerRadius = cornerRadius //value will be set to this corner radius when selected
        }
    }
    
    override func awakeFromNib() { //when it awakes, itll call the setupview func
        self.setupView()
    }
    
    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        self.setupView()
    }
   
    func setupView() {
        self.layer.cornerRadius = cornerRadius
    }
}
