//
//  ReviewViewModel.swift
//  Test
//
//  Created by gdml on 26/05/2020.
//  Copyright © 2020 gdml. All rights reserved.
//

import Foundation

class ReviewViewModel: NSObject {
    private(set) var reviewModel: [DependencyReview]? = [DependencyReview]()
    
    var offset = 0
    var signal: (() -> ())?
    
    fileprivate let dateFormatter: DateFormatter = {
        var dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "RU-ru")
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return dateFormatter
    }()
    
    func getItems(index: Int) {
        let semaphore = DispatchSemaphore(value: 1)
        let value = Router.getReview(val: index)
        defer { self.offset += 20 }
        NetworkingSerivce.request(router: value) { (result: Result<ReviewModel, Error>) in
            do {
                let model = try result.get()
                let items = model.results.map { DependencyReview(review: $0) }
                items.forEach { self.reviewModel?.append($0) }
                if let signal = self.signal {
                signal()
                }
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    func signal(semaphore: @escaping () -> ()) {
        signal = semaphore
    }
    
    func refresh() {
    reviewModel = []
    offset = 0
    getItems(index: offset)
    }
    
    func getItems(text: String, completion: @escaping () -> ()) {
        let value = Router.searchReview(val: text)
        NetworkingSerivce.request(router: value) { (result: Result<ReviewModel, Error>) in
            do {
                let model = try result.get()
                let items = model.results.map { DependencyReview(review: $0) }
                self.reviewModel = []
                self.reviewModel = items
                completion()
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    func filter(text: String, completion: @escaping () -> ()) {
        let dateForm = DateFormatter()
        dateForm.dateFormat = "dd/MM/yyyy"
        guard let date = dateForm.date(from: text) else { return }
        let normally = dateFormatter.string(from: date)
        let items = reviewModel?.filter({ item -> Bool in
            return item.date.contains(normally)
        })
        reviewModel = []
        reviewModel = items
        completion()
    }
    
    func cellViewModel(index: Int) -> DependencyReview? {
        guard let reviewModel = reviewModel else { return nil }
        guard index < reviewModel.count else { return nil }
        return reviewModel[index]
    }
    
}

