//
//  Router.swift
//  Test
//
//  Created by gdml on 26/05/2020.
//  Copyright © 2020 gdml. All rights reserved.
//

import Foundation

protocol RouterProtocol {
    var scheme: String { get }
    var host: String { get }
    var path: String { get }
    var parameters: [URLQueryItem] { get }
    var method: String { get }
}

enum Router: RouterProtocol {
    case getReview(val: Int)
    case getReviewer
    case getReviewerInfo(val: String)
    case searchReview(val: String)
    
    var scheme: String {
        switch self {
        case .getReview, .getReviewer, .getReviewerInfo, .searchReview:
            return "https"
        }
    }
    
    
    var host: String {
        switch self {
        case .getReview, .getReviewer, .getReviewerInfo, .searchReview:
            return "api.nytimes.com"
        }
    }
    
    
    var path: String {
        switch self {
        case .getReview:
            return "/svc/movies/v2/reviews/search.json"
        case .getReviewer:
            return "/svc/movies/v2/critics/all.json"
        case .getReviewerInfo(let name):
            return "/svc/movies/v2/critics/\(name).json"
        case .searchReview:
            return "/svc/movies/v2/reviews/search.json"
        }
    }
    
    
    var parameters: [URLQueryItem] {
        let accessToken = "R0AmPpdbtHzG5syhGXxoQePzj6Ow1Hhq"
        switch self {
        case .getReview(let offset):
            return [URLQueryItem(name: "offset", value: String(offset)),
                    URLQueryItem(name: "api-key", value: accessToken)
            ]
        case .getReviewer, .getReviewerInfo:
            return [URLQueryItem(name: "api-key", value: accessToken)]
        case .searchReview(let val):
            return [URLQueryItem(name: "query", value: val),
                    URLQueryItem(name: "api-key", value: accessToken)]
        }
    }
    var method: String {
        switch self {
        case .getReview, .getReviewer, .getReviewerInfo, .searchReview:
            return "GET"
        }
    }
}
