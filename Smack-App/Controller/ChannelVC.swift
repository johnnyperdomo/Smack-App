//
//  ChannelVC.swift
//  Smack-App
//
//  Created by Johnny Perdomo on 1/13/18.
//  Copyright © 2018 Johnny Perdomo. All rights reserved.
//

//this is for the channel VC that slides out
import UIKit

class ChannelVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.revealViewController().rearViewRevealWidth = self.view.frame.size.width - 60 //this is the width of the reveal view when its open..../{the rear view should take all of the screen size, except 60 points}
    }
}
