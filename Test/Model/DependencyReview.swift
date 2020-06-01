//
//  DependencyReview.swift
//  Test
//
//  Created by gdml on 26/05/2020.
//  Copyright © 2020 gdml. All rights reserved.
//

import Foundation

protocol Review: class {
    var name: String { get }
    var image: String { get }
    var date: String { get }
    var description: String { get }
    var byLine: String { get }
}

final class DependencyReview: Review {
    var name: String
    var image: String
    var date: String
    var description: String
    var byLine: String
    init(review: Results) {
        self.name = review.displayTitle ?? ""
        self.image = review.multimedia?.src ?? ""
        self.date = review.dateUpdated ?? ""
        self.description = review.summaryShort ?? ""
        self.byLine = review.byLine ?? ""
    }
}
