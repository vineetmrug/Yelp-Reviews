//
//  YelpBusiness.swift
//  Yelp Reviews
//
//  Created by Vineet Mrug on 2019-08-12.
//  Copyright © 2019 Vineet Mrug. All rights reserved.
//

import Foundation

public enum BusinessSortMode: String {
    case bestMatch = "best_match"
    case rating = "rating"
    case reviewCount = "review_count"
    case distance = "distance"
    
    func descriptionString() -> String {
        switch self {
        case .bestMatch:
            return "Best match"
        case .rating:
            return "Rating"
        case .reviewCount:
            return "Number of reviews"
        case .distance:
            return "Distance"
        }
    }
}

public struct YelpBusinessSearchResponse {
    var total: Int?
    var businesses = [YelpBusiness]()
    
    private var dictionary: [AnyHashable: Any]?

    public init(dictionary: [AnyHashable: Any]) {
        self.dictionary = dictionary
        
        if let total = dictionary["total"] as? Int {
            self.total = total
        }
        if let businessesArray = dictionary["businesses"] as? [[AnyHashable: Any]] {
            for businessDictionary in businessesArray {
                let yelpBusiness = YelpBusiness(dictionary: businessDictionary)
                self.businesses.append(yelpBusiness)
            }
        }
    }
    
    public func dictionaryRepresentation() -> [AnyHashable: Any]? {
        return self.dictionary
    }
}

public struct YelpBusiness {
    var id: String?
    var name: String?
    var imageUrlString: String?
    var reviewCount: Int?
    var rating: Float?
    var price: String?
    var distance: Float?
    var phone: String?
    var displayPhone: String?
    var displayAddress: [String]?
    var photos: [String]?
    var ratingImageName: String? {
        if let rating = rating {
            return "star_rating_\(rating)"
        }
        return nil
    }

    
    private var dictionary: [AnyHashable: Any]?
    
    public init(dictionary: [AnyHashable: Any]) {
        self.dictionary = dictionary
        
        if let id = dictionary["id"] as? String {
            self.id = id
        }
        if let name = dictionary["name"] as? String {
            self.name = name
        }
        if let imageUrlString = dictionary["image_url"] as? String {
            self.imageUrlString = imageUrlString
        }
        if let reviewCount = dictionary["review_count"] as? NSNumber {
            self.reviewCount = reviewCount.intValue
        }
        if let rating = dictionary["rating"] as? NSNumber {
            self.rating = rating.floatValue
        }
        if let price = dictionary["price"] as? String {
            self.price = price
        }
        if let distance = dictionary["distance"] as? NSNumber {
            self.distance = distance.floatValue
        }
        if let phone = dictionary["phone"] as? String {
            self.phone = phone
        }
        if let displayPhone = dictionary["display_phone"] as? String {
            self.displayPhone = displayPhone
        }
        if let locationDictionary = dictionary["location"] as? [AnyHashable: Any], let displayAddress = locationDictionary["display_address"] as? [String] {
            self.displayAddress = displayAddress
        }
        if let photos = dictionary["photos"] as? [String] {
            self.photos = photos
        }
    }
    
    public func dictionaryRepresentation() -> [AnyHashable: Any]? {
        return self.dictionary
    }
}
