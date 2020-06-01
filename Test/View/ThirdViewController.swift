//
//  ThirdViewController.swift
//  Test
//
//  Created by gdml on 29/05/2020.
//  Copyright © 2020 gdml. All rights reserved.
//

import UIKit

class ThirdViewController: UIViewController{
    var viewModel = ReviewerInfoViewModel()
    
    @IBOutlet weak var status: UILabel! {
        didSet {
            status.layer.masksToBounds = true
            status.layer.cornerRadius = 5
        }
    }
    @IBOutlet weak var isImage: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var time: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!//API не возвращает фильмов от критика
    var data: DependencyCritic!
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.register(UINib(nibName: "ReviewerInfo", bundle: .main), forCellWithReuseIdentifier: "Cell")
        getReviewer()
    }
    
    fileprivate func getReviewer() {
         isImage.setCustomImage(data.multim)
         name.text = data.name
         status.text = data.status
     }
}
extension ThirdViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! ReviewerInfo
        return cell
    }
}
