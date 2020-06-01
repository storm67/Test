//
//  DependencyCritic.swift
//  Test
//
//  Created by gdml on 26/05/2020.
//  Copyright © 2020 gdml. All rights reserved.
//

import Foundation

protocol Reviewer: class {
    var name: String { get }
    var status: String { get }
    var multim: String? { get }
}

final class DependencyCritic: Reviewer {
    var name: String
    var status: String
    var multim: String?
    init(model: CriticResults) {
        self.name = model.displayName
        self.status = model.status ?? ""
        self.multim = model.multimedia?.resource?.src ?? nil
    }
}
