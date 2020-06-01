//
//  ReviewCell.swift
//  Test
//
//  Created by gdml on 26/05/2020.
//  Copyright © 2020 gdml. All rights reserved.
//

import Foundation
import UIKit

final class ReviewCell: UITableViewCell {
    
    @IBOutlet weak var isImage: UIImageView! {
        didSet {
            isImage.layer.cornerRadius = 10
            isImage.layer.masksToBounds = true
        }
    }
    @IBOutlet weak var twoDate: UILabel!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var unknown: UILabel!
    @IBOutlet weak var date: UILabel!
    var viewModel: DependencyReview? {
        didSet {
            guard let viewModel = viewModel else { return }
            let textArray = viewModel.date.components(separatedBy: " ")
            isImage.setCustomImage(viewModel.image)
            name.text = viewModel.name
            unknown.text = viewModel.byLine
            date.text = textArray[0]
            twoDate.text = textArray[1]
            textView.text = viewModel.description
        }
    }
     override func prepareForReuse() {
        super.prepareForReuse()
        isImage.image = nil
       }
}
