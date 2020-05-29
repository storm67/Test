//
//  DataModel.swift
//  Test
//
//  Created by gdml on 28/05/2020.
//  Copyright © 2020 gdml. All rights reserved.
//

import Foundation

struct ImageModel {
    public private(set) var url: URL?
    let order: Int
    
    init(url: String?, order: Int) {
        self.url = url?.toURL
        self.order = order
    }
}
public extension String {
    var toURL: URL? {
        return URL(string: self)
    }
}
