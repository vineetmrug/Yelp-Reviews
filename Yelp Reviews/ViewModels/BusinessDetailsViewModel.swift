//
//  BusinessDetailsViewModel.swift
//  Yelp Reviews
//
//  Created by Vineet Mrug on 2019-08-13.
//  Copyright © 2019 Vineet Mrug. All rights reserved.
//

import Foundation
import UIKit

enum BusinessDetailsTableViewSection {
    case businessDetails(business: YelpBusiness)
    case reviews(reviews: [YelpReview])
    
    func getTableViewRows() -> [BusinessDetailsTableViewRow] {
        switch self {
        case .businessDetails(let business):
            if let photos = business.photos, !photos.isEmpty {
                return [.mainImage, .additionalImages, .businessDetails]
            }
            return [.mainImage, .businessDetails]
        case .reviews(let reviews):
            return Array(repeating: .review, count: reviews.count)
        }
    }
    
    func title() -> String? {
        switch self {
        case .reviews(_):
            return "Reviews"
        default:
            return nil
        }
    }
}

enum BusinessDetailsTableViewRow {
    case mainImage
    case additionalImages
    case businessDetails
    case review
    
    func getRowHeight(tableView: UITableView) -> CGFloat {
        switch self {
        case .mainImage:
            let aspectRatio: CGFloat = 1.25
            return tableView.frame.width/aspectRatio
        case .additionalImages:
            return 120
        default:
            return UITableView.automaticDimension
        }
    }
}

class BusinessDetailsViewModel {
    
    let networkManager = NetworkManager.shared
    var businessId: String
    var business: YelpBusiness?
    var reviews: [YelpReview]?
    var tableViewSections: [BusinessDetailsTableViewSection] {
        if let business = business, let reviews = reviews, !reviews.isEmpty {
            return [.businessDetails(business: business), .reviews(reviews: reviews)]
        } else if let business = business {
            return [.businessDetails(business: business)]
        }
        return []
    }
    var mainImageUrlString: String?
    var isDataLoadingComplete: Bool {
        return business != nil && reviews != nil
    }
    
    
    init(businessId: String) {
        self.businessId = businessId
    }
    
    func getYelpBusinessDetails(completion: @escaping (String?) -> Void) {
        networkManager.getBusinessDetails(id: businessId, completion: { [weak self] result in
            switch result {
            case .success(let business):
                self?.business = business
                completion(nil)
            case .error(let errorMessage):
                completion(errorMessage)
            }
        })
    }
    
    func getReviews(completion: @escaping (String?) -> Void) {
        networkManager.getReviews(id: businessId, completion: { [weak self] result in
            switch result {
            case .success(let reviews):
                self?.reviews = reviews
                completion(nil)
            case .error(let errorMessage):
                completion(errorMessage)
            }
        })
    }
    
    func callBusiness() {
        if let phoneNumber = business?.phone, let phoneCallUrl = URL(string: "tel://\(phoneNumber)") {
            if UIApplication.shared.canOpenURL(phoneCallUrl) {
                UIApplication.shared.open(phoneCallUrl, options: [:], completionHandler: nil)
            }
        }
    }
}
