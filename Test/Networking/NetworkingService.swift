//
//  NetworkingService.swift
//  Test
//
//  Created by gdml on 26/05/2020.
//  Copyright © 2020 gdml. All rights reserved.
//

import Foundation

protocol NetworkProtocol: class {
    static func request<T: Codable>(router: Router, completion: @escaping (Result<T, Error>) -> ())
}

final class NetworkingSerivce: NetworkProtocol {
    class func request<T: Codable>(router: Router, completion: @escaping (Result<T, Error>) -> ()) {
        // 2.
        var components = URLComponents()
        components.scheme = router.scheme
        components.host = router.host
        components.path = router.path
        components.queryItems = router.parameters
        // 3.
        guard let url = components.url else { return }
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = router.method
        // 4.
        print(urlRequest)
        let session = URLSession(configuration: .default)
        let dataTask = session.dataTask(with: urlRequest) { data, response, error in
            // 5.
            guard error == nil else {
                completion(.failure(error!))
                print(error?.localizedDescription as Any)
                return
            }
            guard response != nil else {
                return
            }
            guard let data = data else {
                return
            }
            do {
                let responseObject = try JSONDecoder().decode(T.self, from: data)
                DispatchQueue.main.async {
                    completion(.success(responseObject))
                }
            } catch {
                print(error.localizedDescription)
            }
        }
        dataTask.resume()
    }
}
