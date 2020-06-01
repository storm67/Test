//
//  ReviewModel.swift
//  Test
//
//  Created by gdml on 26/05/2020.
//  Copyright © 2020 gdml. All rights reserved.
//

import Foundation

struct ReviewModel: Codable {
    let results: [Results]
}
struct Results: Codable {
    var displayTitle: String?
    var summaryShort: String?
    var dateUpdated: String?
    var multimedia: Multimedia?
    var byLine: String?
    enum CodingKeys: String, CodingKey {
        case byLine = "byline"
        case displayTitle = "display_title"
        case summaryShort = "summary_short"
        case dateUpdated = "date_updated"
        case multimedia = "multimedia"
    }
}
struct Multimedia: Codable {
    var src: String?
}

//MARK: Critic Model

struct CriticModel: Codable {
    let results: [CriticResults]
}
struct CriticResults: Codable {
    var displayName: String
    var status: String?
    var multimedia: Resource?
    enum CodingKeys: String, CodingKey {
        case displayName = "display_name"
        case status = "status"
        case multimedia = "multimedia"
    }
}
struct CriticMultimedia: Codable {
    var src: String
}
struct Resource: Codable {
    var resource: CriticMultimedia?
}
