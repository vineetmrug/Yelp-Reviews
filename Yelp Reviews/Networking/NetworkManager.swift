//
//  NetworkManager.swift
//  Yelp Reviews
//
//  Created by Vineet Mrug on 2019-08-12.
//  Copyright © 2019 Vineet Mrug. All rights reserved.
//

import Foundation

public enum YelpAPIResult<Value> {
    case success(Value)
    case error(String)
}
typealias YelpJSONCompletionHandler = (YelpAPIResult<[AnyHashable: Any]>) -> Void

public struct NetworkManager {
    public static let shared = NetworkManager()
    private var session: URLSession

    private init() {
        let sessionConfiguration = URLSessionConfiguration.default
        sessionConfiguration.httpAdditionalHeaders = ["Authorization": authorizationString]
        self.session = URLSession(configuration: sessionConfiguration)
    }

    private func makeYelpApiCall(endpoint: String, completion: @escaping YelpJSONCompletionHandler) {
        let urlString = yelpBaseUrlString + endpoint
        if let url = URL(string: urlString) {
            let request = URLRequest(url: url)
            let task = session.dataTask(with: request, completionHandler: { data, response, error in
                if let error = error {
                    completion(.error(error.localizedDescription))
                    return
                }
                if let httpResponse = response as? HTTPURLResponse {
                    guard (200...299).contains(httpResponse.statusCode) else {
                        completion(.error(HTTPURLResponse.localizedString(forStatusCode: httpResponse.statusCode)))
                        return
                    }
                }
                if let data = data, let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [AnyHashable: Any] {
                    completion(.success(json))
                }
            })
            task.resume()
        }
    }

    func searchBusinesses(searchTerm: String, location: String? = "toronto", limit: Int? = 10, sortMode: BusinessSortMode? = nil, completion: @escaping (YelpAPIResult<[YelpBusiness]>) -> Void) {
        let businessSearchEndpoint = YelpEndpoint.businessSearch(searchTerm: searchTerm, location: location, limit: limit, sortMode: sortMode).urlString()
        makeYelpApiCall(endpoint: businessSearchEndpoint, completion: { result in
            switch result {
            case .success(let json):
                let yelpBusinessesSearchResponse = YelpBusinessSearchResponse(dictionary: json)
                completion(.success(yelpBusinessesSearchResponse.businesses))
            case .error(let errorMessage):
                completion(.error(errorMessage))
            }
        })
    }
    
    func getBusinessDetails(id: String, completion: @escaping (YelpAPIResult<YelpBusiness>) -> Void) {
        makeYelpApiCall(endpoint: YelpEndpoint.businessDetails(businessId: id).urlString(), completion: { result in
            switch result {
            case .success(let json):
                let yelpBusiness = YelpBusiness(dictionary: json)
                completion(.success(yelpBusiness))
            case .error(let errorMessage):
                completion(.error(errorMessage))
            }
        })
    }

    func getReviews(id: String, completion: @escaping (YelpAPIResult<[YelpReview]>) -> Void) {
        makeYelpApiCall(endpoint: YelpEndpoint.reviews(businessId: id).urlString(), completion: { result in
            switch result {
            case .success(let json):
                let yelpReviewsResponse = YelpReviewsResponse(dictionary: json)
                completion(.success(yelpReviewsResponse.reviews))
            case .error(let errorMessage):
                completion(.error(errorMessage))
            }
        })
    }
}
