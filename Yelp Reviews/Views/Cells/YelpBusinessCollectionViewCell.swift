//
//  YelpBusinessCollectionViewCell.swift
//  Yelp Reviews
//
//  Created by Vineet Mrug on 2019-08-13.
//  Copyright © 2019 Vineet Mrug. All rights reserved.
//

import UIKit
import SDWebImage

class YelpBusinessCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var mainImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var starRatingImageView: UIImageView!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var reviewCountLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    
    func configureView(business: YelpBusiness) {
        nameLabel.text = business.name
        priceLabel.text = business.price
        if let rating = business.rating {
            ratingLabel.text = "\(rating)"
        }
        if let reviewCount = business.reviewCount {
            reviewCountLabel.text = "(\(reviewCount))"
        }
        if let starRatingImageName = business.ratingImageName {
            starRatingImageView.image = UIImage(named: starRatingImageName)
        }
        if let imageUrlString = business.imageUrlString {
            mainImageView.sd_setImage(with: URL(string: imageUrlString), placeholderImage: UIImage(named: "placeholder"), options: [], completed: nil)
        } else {
            mainImageView.image = UIImage(named: "placeholder")
        }
    }
}
