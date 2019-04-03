//
//  NetworkRequestHelper.swift
//  Hacker-news
//
//  Created by Prerna Kumari on 01/04/19.
//  Copyright © 2019 Prerna Kumari. All rights reserved.
//

import Foundation

final class NeworkRequestHelper {

    private(set) var requestInPRogress = false

    static var sharedInstance = NeworkRequestHelper()

    private init() {}

    func makeNetworkCall(for queryString: String, page: Int = 0, completion: @escaping (([[String: Any]]) -> ())) {
        guard !requestInPRogress else {
            return
        }
        var urlComponent = URLComponents(string: "https://hn.algolia.com/api/v1/search")
        urlComponent?.queryItems = [
            URLQueryItem(name: "query", value: queryString),
            URLQueryItem(name: "page", value: "\(page)"),
            URLQueryItem(name: "hitsPerPage", value: "\(NewsTableViewController.maximumResponseCount)")
        ]
        guard let url = urlComponent?.url else {
            return
        }

        requestInPRogress = true
        URLSession.shared.dataTask(with: url) { [weak self] (data, response, error) in
            guard let strongSelf = self else {
                return
            }
            strongSelf.requestInPRogress = false
            if let error = error {
                print("network request failed with error: \(error.localizedDescription)")
                completion([])
                return
            }
            if let dataResponse = data {
                do {
                    let jsonResponse = try JSONSerialization.jsonObject(with:
                        dataResponse, options: []) as? [String: Any]
                    if let dataArray = jsonResponse?["hits"] as? [[String: Any]] {
                        print("printing dataArray")
                        print(dataArray)
                        completion(dataArray)
                    }
                } catch let parsingError {
                    print("Error", parsingError)
                }
            }
        }.resume()
        
    }
}
