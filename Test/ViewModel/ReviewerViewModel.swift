//
//  ReviewerViewModel.swift
//  Test
//
//  Created by gdml on 26/05/2020.
//  Copyright © 2020 gdml. All rights reserved.
//

import Foundation

class ReviewerViewModel: NSObject {
    private(set) var reviewModel: [DependencyCritic]? = [DependencyCritic]()
    
    func getItems() {
        NetworkingSerivce.request(router: Router.getReviewer) { (result: Result<CriticModel, Error>) in
            do {
                let model = try result.get()
                let items = model.results.map { DependencyCritic(model: $0) }
                self.reviewModel = items
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
     func refresh() {
       reviewModel = []
       getItems()
    }
    
    func filter(text: String, completion: @escaping () -> ()) {
        let items = reviewModel?.filter({ item -> Bool in
        return item.name.contains(text)
        })
        reviewModel = []
        reviewModel = items
        completion()
    }
    
    func cellViewModel(index: Int) -> DependencyCritic? {
        guard let reviewModel = reviewModel else { return nil }
        guard index < reviewModel.count else { return nil }
        return reviewModel[index]
    }
}



