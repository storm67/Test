//
//  ReviewerCell.swift
//  Test
//
//  Created by gdml on 27/05/2020.
//  Copyright © 2020 gdml. All rights reserved.
//

import UIKit

class ReviewerCell: UICollectionViewCell {
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var isImage: UIImageView! {
        didSet {
            isImage.layer.cornerRadius = 7
            isImage.layer.masksToBounds = true
        }
    }
    var viewModel: DependencyCritic? {
        didSet {
            guard let viewModel = viewModel else { return }
            name.text = viewModel.name
            isImage.setCustomImage(viewModel.multim ?? "")
        }
    }
    override func prepareForReuse() {
        super.prepareForReuse()
        isImage.image = UIImage(named: "1363011")
    }
    override func awakeFromNib() {
        super.awakeFromNib()
    }
}
