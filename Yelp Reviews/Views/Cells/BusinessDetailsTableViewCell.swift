//
//  BusinessDetailsTableViewCell.swift
//  Yelp Reviews
//
//  Created by Vineet Mrug on 2019-08-15.
//  Copyright © 2019 Vineet Mrug. All rights reserved.
//

import UIKit

class BusinessDetailsTableViewCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var starRatingImageView: UIImageView!
    @IBOutlet weak var reviewCountLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var phoneNumberButton: UIButton!
    
    func configureView(business: YelpBusiness?) {
        guard let business = business else { return }
        nameLabel.text = business.name
        priceLabel.text = business.price
        phoneNumberButton.setTitle(business.displayPhone, for: .normal)
        if let reviewCount = business.reviewCount {
            reviewCountLabel.text = "(\(reviewCount) Reviews)"
        }
        if let starRatingImageName = business.ratingImageName {
            starRatingImageView.image = UIImage(named: starRatingImageName)
        }
        if let displayAddressArray = business.displayAddress {
            addressLabel.text = displayAddressArray.joined(separator: "\n")
        }
    }
}
