//
//  HTTPEndpoints.swift
//  Yelp Reviews
//
//  Created by Vineet Mrug on 2019-08-12.
//  Copyright © 2019 Vineet Mrug. All rights reserved.
//

import Foundation

private let apiKey = "GNR-88EAzctyxGWGISXnHr2PIc10Me1Ba57ocy-aUcUc9CPkGBpMQw_Q4IVLpAejBgINFneSlmLmBWRvrj3FpdcOhWhkZDNEYB_CenLNvfSUznZ_B-Uh2UEHWvVKXXYx"
let authorizationString = "Bearer " + apiKey

let yelpBaseUrlString = "https://api.yelp.com/v3"

public enum YelpEndpoint {
    case businessSearch(searchTerm: String, location: String?, limit: Int?, sortMode: BusinessSortMode?)
    case businessDetails(businessId: String)
    case reviews(businessId: String)
    
    public func urlString() -> String {
        switch self {
        case .businessSearch(let searchTerm, let location, let limit, let sortMode):
            let encodedSearchTerm = searchTerm.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) ?? searchTerm
            var urlString = "/businesses/search?term=\(encodedSearchTerm)"
            if let location = location {
                urlString += "&location=\(location)"
            }
            if let sortMode = sortMode {
                urlString += "&sort_by=\(sortMode.rawValue)"
            }
            if let limit = limit {
                urlString += "&limit=\(limit)"
            }
            return urlString
        case .businessDetails(let businessId):
            return "/businesses/\(businessId)"
        case .reviews(let businessId):
            return "/businesses/\(businessId)/reviews"
        }
    }
}
