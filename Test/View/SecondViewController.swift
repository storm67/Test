//
//  SecondViewController.swift
//  Test
//
//  Created by gdml on 27/05/2020.
//  Copyright © 2020 gdml. All rights reserved.
//

import Foundation
import UIKit

fileprivate protocol SecondViewProtocol: class {
    func refresher(sender: UIRefreshControl)
    func tryGetModel()
    func editingStart(_ sender: UITextField)
    func layout()
}

final class SecondViewController: UIViewController, SecondViewProtocol {
    @IBOutlet weak var searchField: UITextField!
    @IBOutlet weak var collectionView: UICollectionView!
    var viewModel = ReviewerViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        layout()
    }
    
    @objc fileprivate func refresher(sender: UIRefreshControl) {
        viewModel.refresh()
        DispatchQueue.main.asyncAfter(deadline: .now()) {
            self.collectionView.reloadData()
            sender.endRefreshing()
        }
    }
   fileprivate func tryGetModel() {
        viewModel.getItems()
        if viewModel.reviewModel != nil {
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }
    }
    fileprivate lazy var refresh: UIRefreshControl = {
        let refresh = UIRefreshControl()
        refresh.addTarget(self, action: #selector(refresher(sender:)), for: .valueChanged)
        return refresh
    }()
    
    @objc fileprivate func editingStart(_ sender: UITextField) {
           guard let text = sender.text else { return }
               viewModel.filter(text: text) { [weak self] in
                   self?.collectionView.reloadData()
               }
           }
    fileprivate func layout() {
        collectionView.register(UINib(nibName: "ReviewerCell", bundle: .main), forCellWithReuseIdentifier: "Cell")
        tryGetModel()
        collectionView.refreshControl = refresh
        searchField.addTarget(self, action: #selector(editingStart(_:)), for: .editingChanged)
        searchField.setLeftPaddingPoints(24)
    }
}

extension SecondViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "ThirdViewController") as! ThirdViewController
        vc.data = viewModel.reviewModel?[indexPath.row]
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let model = viewModel.reviewModel?.count else { return 0 }
        return model
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as? ReviewerCell else { return UICollectionViewCell() }
        cell.viewModel = viewModel.cellViewModel(index: indexPath.row)
        
        return cell
    }
}


