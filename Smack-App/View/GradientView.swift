//
//  GradientView.swift
//  Smack-App
//
//  Created by Johnny Perdomo on 1/14/18.
//  Copyright © 2018 Johnny Perdomo. All rights reserved.
//

import UIKit

@IBDesignable //lets it know, this file needs to render inside the story board
class GradientView: UIView {
    
    @IBInspectable var topColor: UIColor = #colorLiteral(red: 0.5818830132, green: 0.2156915367, blue: 1, alpha: 1) { // @IBInspectable, lets you change the properties in the app
        didSet { //when we set the new uicolor, didset
            self.setNeedsLayout() //invalidates current layout, and updates it to whatever you chose
        }
    }
  
    @IBInspectable var bottomColor: UIColor = #colorLiteral(red: 0.4745098054, green: 0.8392156959, blue: 0.9764705896, alpha: 1) { // @IBInspectable, lets you change the properties in the app
        didSet { //when we set the new uicolor, didset
            self.setNeedsLayout() //invalidates current layout, and updates it to whatever you chose
        }
    }
    
    //when we update the views using the setNeedsLayout(), this function is called...//this is what happens after the update
    override func layoutSubviews() {
        let gradientLayer = CAGradientLayer() //gradients need three things...colors, start & end point, how big its gonna be
        gradientLayer.colors = [topColor.cgColor, bottomColor.cgColor] //these are the colors youre able to edit
        gradientLayer.startPoint = CGPoint(x: 0, y: 0) //(0,0) starts top left using the ios coordinate system.... we know that the gradient goes from top to bottm because it starts at (0,0) and ends at (1,1)
        gradientLayer.endPoint = CGPoint(x: 1, y: 1) // (1,1) is the bottom right corner of screen using the ios coordinate system
        gradientLayer.frame = self.bounds //the size of the gradient layer in the view
        self.layer.insertSublayer(gradientLayer, at: 0) //this is to add the layer to the UIView's layer
    }
    
}
