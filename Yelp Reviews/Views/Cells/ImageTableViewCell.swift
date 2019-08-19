//
//  ImageTableViewCell.swift
//  Yelp Reviews
//
//  Created by Vineet Mrug on 2019-08-15.
//  Copyright © 2019 Vineet Mrug. All rights reserved.
//

import UIKit
import SDWebImage

class ImageTableViewCell: UITableViewCell {

    @IBOutlet weak var mainImageView: UIImageView!
    
    func configureView(imageUrlString: String?) {
        if let imageUrlString = imageUrlString {
            mainImageView.sd_setImage(with: URL(string: imageUrlString), placeholderImage: UIImage(named: "placeholder"), options: [], completed: nil)
        } else {
            mainImageView.image = UIImage(named: "placeholder")
        }
    }
}
