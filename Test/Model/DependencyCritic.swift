//
//  DependencyCritic.swift
//  Test
//
//  Created by gdml on 26/05/2020.
//  Copyright © 2020 gdml. All rights reserved.
//

import Foundation

class DependencyCritic {
    var name: String
    var status: String
    var multim: String?
    init(model: CriticResults) {
        self.name = model.displayName
        self.status = model.status ?? ""
        self.multim = model.multimedia?.resource?.src ?? nil
    }
}
