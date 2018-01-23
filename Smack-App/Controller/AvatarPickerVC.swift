//
//  AvatarPickerVC.swift
//  Smack-App
//
//  Created by Johnny Perdomo on 1/22/18.
//  Copyright © 2018 Johnny Perdomo. All rights reserved.
//

import UIKit

class AvatarPickerVC: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var segmentControl: UISegmentedControl!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self //this is for collectionview
        collectionView.dataSource = self //this is for collectionview

        // Do any additional setup after loading the view.
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell { //this is for collectionview
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "avatarCell", for: indexPath) as? AvatarCell{
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
    }
    
    @IBAction func backPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil) //to close the page if you click on the back button
    }
    
}
