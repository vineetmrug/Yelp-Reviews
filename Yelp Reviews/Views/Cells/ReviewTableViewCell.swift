//
//  ReviewTableViewCell.swift
//  Yelp Reviews
//
//  Created by Vineet Mrug on 2019-08-16.
//  Copyright © 2019 Vineet Mrug. All rights reserved.
//

import UIKit
import SDWebImage

class ReviewTableViewCell: UITableViewCell {

    @IBOutlet weak var userProfileImageView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var starRatingImageView: UIImageView!
    @IBOutlet weak var reviewDateLabel: UILabel!
    @IBOutlet weak var reviewTextLabel: UILabel!

    func configureView(review: YelpReview?) {
        guard let review = review else { return }
        userNameLabel.text = review.user?.name
        if let profileImageUrlString = review.user?.imageUrlString {
            userProfileImageView.sd_setImage(with: URL(string: profileImageUrlString), placeholderImage: UIImage(named: "placeholder"), options: [], completed: nil)
        } else {
            userProfileImageView.image = UIImage(named: "placeholdrr")
        }
        if let starRatingImageName = review.ratingImageName {
            starRatingImageView.image = UIImage(named: starRatingImageName)
        }
        if let timeCreated = review.timeCreated {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MMM dd, YYYY"
            reviewDateLabel.text = dateFormatter.string(from: timeCreated)
        }
        reviewTextLabel.text = review.text
    }
}
