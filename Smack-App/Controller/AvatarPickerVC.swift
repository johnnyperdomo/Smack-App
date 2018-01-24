//
//  AvatarPickerVC.swift
//  Smack-App
//
//  Created by Johnny Perdomo on 1/22/18.
//  Copyright © 2018 Johnny Perdomo. All rights reserved.
//

import UIKit

class AvatarPickerVC: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    //Outlets
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var segmentControl: UISegmentedControl!
    
    //Variables
    var avatarType = AvatarType.dark //this stores the avatarType we currently selected
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self //this is for collectionview
        collectionView.dataSource = self //this is for collectionview

        // Do any additional setup after loading the view.
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell { //this is for collectionview
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "avatarCell", for: indexPath) as? AvatarCell{
            cell.configureCell(index: indexPath.item, type: avatarType)
            return cell
        }
        return AvatarCell()
    }

    func numberOfSections(in collectionView: UICollectionView) -> Int { //this is for collectionview
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int { //this is for collectionview
        return 28
    }
    
    @IBAction func segmentControlChanged(_ sender: Any) {
        if segmentControl.selectedSegmentIndex == 0 {
            avatarType = .dark
        } else {
            avatarType = .light
        }
        collectionView.reloadData() //this will call all the collection view functions again.
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        //were using this function to organize the cells on different size iphones
        var numOfColumns : CGFloat = 3
        if UIScreen.main.bounds.width > 320 {
            numOfColumns = 4
        }
        
        //the size of the cells configured into each iphone
        let spaceBetweenCells : CGFloat = 10
        let padding : CGFloat = 40
        let cellDimension = ((collectionView.bounds.width - padding) - (numOfColumns - 1) * spaceBetweenCells) / numOfColumns
        return CGSize(width: cellDimension, height: cellDimension)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if avatarType == .dark {
            UserDataService.instance.setAvatarName(avatarName: "dark\(indexPath.item)") //this will update the name of the Avatar you chose
        } else {
            UserDataService.instance.setAvatarName(avatarName: "light\(indexPath.item)")
        }
        self.dismiss(animated: true, completion: nil) //dismisses once we chose the avatarName
    }
    
    @IBAction func backPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil) //to close the page if you click on the back button
    }
    
}
