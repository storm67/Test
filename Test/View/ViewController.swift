//
//  ViewController.swift
//  Test
//
//  Created by gdml on 26/05/2020.
//  Copyright © 2020 gdml. All rights reserved.
//
import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var secondView: UIView!
    @IBOutlet weak var firstView: UIView!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var generalView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        navigationItem.title = "Reviews"
        firstView.isHidden = true
    }
    
    @IBAction func switcher(_ sender: Any) {
        switch segmentedControl.selectedSegmentIndex {
        case 0:
        generalView.backgroundColor = .systemOrange
        navigationController?.navigationBar.barTintColor = .systemOrange
        navigationItem.title = "Reviews"
        firstView.isHidden = true
        secondView.isHidden = false
        case 1:
        generalView.backgroundColor = .systemBlue
        navigationController?.navigationBar.barTintColor = .systemBlue
        firstView.isHidden = false
        secondView.isHidden = true
        navigationItem.title = "Critics"
        default:
            break
        }
    }
    

}
