//
//  BusinessSearchViewModel.swift
//  Yelp Reviews
//
//  Created by Vineet Mrug on 2019-08-13.
//  Copyright © 2019 Vineet Mrug. All rights reserved.
//

import Foundation

class BusinessSearchViewModel {
    
    let networkManager = NetworkManager.shared
    var businesses = [YelpBusiness]()
    var sortMode: BusinessSortMode = .bestMatch
    
    func searchYelpBusinesses(searchTerm: String, completion: @escaping (String?) -> Void) {
        networkManager.searchBusinesses(searchTerm: searchTerm, sortMode: sortMode, completion: { [weak self] result in
            switch result {
            case .success(let businesses):
                self?.businesses = businesses
                completion(nil)
            case .error(let errorMessage):
                completion(errorMessage)
            }
        })
    }
}
