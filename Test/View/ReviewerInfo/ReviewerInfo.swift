//
//  ReviewerInfo.swift
//  Test
//
//  Created by gdml on 29/05/2020.
//  Copyright © 2020 gdml. All rights reserved.
//

import UIKit

final class ReviewerInfo: UICollectionViewCell {

     @IBOutlet weak var isImage: UIImageView! {
            didSet {
                isImage.layer.cornerRadius = 10
                isImage.layer.masksToBounds = true
            }
        }
        @IBOutlet weak var name: UILabel!
        @IBOutlet weak var textView: UITextView!
        @IBOutlet weak var unknown: UILabel!
        @IBOutlet weak var date: UILabel!
        var viewModel: DependencyReview? {
            didSet {
                guard let viewModel = viewModel else { return }
                isImage.setCustomImage(viewModel.image)
                name.text = viewModel.name
                date.text = viewModel.date.replacingOccurrences(of: "-", with: "/").replacingOccurrences(of: " ", with: "     ") //суперкостыль
                textView.text = viewModel.description
            }
        }
         override func prepareForReuse() {
            super.prepareForReuse()
            isImage.image = nil
           }
    }

