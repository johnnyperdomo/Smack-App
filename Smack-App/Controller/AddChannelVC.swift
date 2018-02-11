//
//  AddChannelVC.swift
//  Smack-App
//
//  Created by Johnny Perdomo on 2/11/18.
//  Copyright © 2018 Johnny Perdomo. All rights reserved.
//

import UIKit

class AddChannelVC: UIViewController {

    //Outlets
    @IBOutlet weak var nameTxt: UITextField!
    @IBOutlet weak var channelDescription: UITextField!
    @IBOutlet weak var bgView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView() //to call the function
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func createChannelPressed(_ sender: Any) {
        
    }
    
    
    @IBAction func closeModalPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil) //to close the screen
    }
    

    func setupView() {
        let closeTouch = UITapGestureRecognizer(target: self, action: #selector(AddChannelVC.closeTap(_:))) //to close the screen if tap outside the screen
        bgView.addGestureRecognizer(closeTouch) //to add the gesture
        
        nameTxt.attributedPlaceholder = NSAttributedString(string: "name", attributes: [NSAttributedStringKey.foregroundColor : SMACK_PURPLE_PLACE_HOLDER]) //to set the placeholder color of the placeholder
        channelDescription.attributedPlaceholder = NSAttributedString(string: "description", attributes: [NSAttributedStringKey.foregroundColor : SMACK_PURPLE_PLACE_HOLDER]) //to set the placeholder color of the placeholder
        
    }
    
    @objc func closeTap(_ recognizer: UITapGestureRecognizer) { //this is the action, do this when setting up a UITapGestureRecognizer
        dismiss(animated: true, completion: nil)
    }
    
}
