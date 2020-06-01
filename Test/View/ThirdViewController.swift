//
//  ThirdViewController.swift
//  Test
//
//  Created by gdml on 29/05/2020.
//  Copyright © 2020 gdml. All rights reserved.
//

import UIKit

fileprivate protocol ThirdViewProtocol: class {
    var data: DependencyCritic? { get }
    func getReviewer()
}

final class ThirdViewController: UIViewController, ThirdViewProtocol {
    var viewModel = ReviewerInfoViewModel()
    weak var data: DependencyCritic?
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
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.register(UINib(nibName: "ReviewerInfo", bundle: .main), forCellWithReuseIdentifier: "Cell")
        getReviewer()
    }
    
    fileprivate func getReviewer() {
        guard let data = data else { return }
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
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as? ReviewerInfo else { return UICollectionViewCell() }
        return cell
    }
}
