//
//  YelpReview.swift
//  Yelp Reviews
//
//  Created by Vineet Mrug on 2019-08-14.
//  Copyright © 2019 Vineet Mrug. All rights reserved.
//

import Foundation

public struct YelpReviewsResponse {
    var total: Int?
    var reviews = [YelpReview]()
    var possibleLanguages: [String]?
    
    public init(dictionary: [AnyHashable: Any]) {
        if let total = dictionary["total"] as? Int {
            self.total = total
        }
        if let reviewsArray = dictionary["reviews"] as? [[AnyHashable: Any]] {
            for reviewDictionary in reviewsArray {
                let yelpReview = YelpReview(dictionary: reviewDictionary)
                self.reviews.append(yelpReview)
            }
        }
        if let possibleLanguages = dictionary["possible_languages"] as? [String] {
            self.possibleLanguages = possibleLanguages
        }
    }
}

public struct YelpReview {
    var id: String?
    var rating: Int?
    var user: YelpUser?
    var text: String?
    var timeCreated: Date?
    var urlString: String?
    var ratingImageName: String? {
        if let rating = rating {
            return "star_rating_\(rating).0"
        }
        return nil
    }


    public init(dictionary: [AnyHashable: Any]) {
        if let id = dictionary["id"] as? String {
            self.id = id
        }
        if let rating = dictionary["rating"] as? Int {
            self.rating = rating
        }
        if let userDictionary = dictionary["user"] as? [AnyHashable: Any] {
            self.user = YelpUser(dictionary: userDictionary)
        }
        if let text = dictionary["text"] as? String {
            self.text = text
        }
        if let timeCreatedString = dictionary["time_created"] as? String {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "YYYY-MM-dd HH:mm:ss"
            self.timeCreated = dateFormatter.date(from: timeCreatedString)
        }
        if let url = dictionary["url"] as? String {
            self.urlString = url
        }
    }
}

public struct YelpUser {
    var name: String?
    var id: String?
    var imageUrlString: String?
    var profileUrlString: String?
    
    public init(dictionary: [AnyHashable: Any]) {
        if let name = dictionary["name"] as? String {
            self.name = name
        }
        if let id = dictionary["id"] as? String {
            self.id = id
        }
        if let imageUrl = dictionary["image_url"] as? String {
            self.imageUrlString = imageUrl
        }
        if let profileUrl = dictionary["profile_url"] as? String {
            self.profileUrlString = profileUrl
        }
    }
}
