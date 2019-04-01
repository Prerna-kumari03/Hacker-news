//
//  NetworkRequestHelper.swift
//  Hacker-news
//
//  Created by Prerna Kumari on 01/04/19.
//  Copyright © 2019 Prerna Kumari. All rights reserved.
//

import Foundation

final class NeworkRequestHelper {

    static var totalCount = 0
    
    static func makeNetworkCall(for queryString: String, completion: @escaping (([[String: Any]]) -> ())) {
        var urlComponent = URLComponents(string: "https://hn.algolia.com/api/v1/search")
        urlComponent?.queryItems = [URLQueryItem(name: "query", value: queryString)]
        guard let url = urlComponent?.url else {
            return
        }
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let error = error {
                print("network request failed with error: \(error.localizedDescription)")
                completion([])
                return
            }
            if let dataResponse = data {
                do {
                    let jsonResponse = try JSONSerialization.jsonObject(with:
                        dataResponse, options: []) as? [String: Any]
                    totalCount = jsonResponse?["nbPages"] as? Int ?? 0
                    print("totalCount \(totalCount)")
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
