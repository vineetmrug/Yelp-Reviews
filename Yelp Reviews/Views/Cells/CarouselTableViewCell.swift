//
//  CarouselTableViewCell.swift
//  Yelp Reviews
//
//  Created by Vineet Mrug on 2019-08-15.
//  Copyright © 2019 Vineet Mrug. All rights reserved.
//

import UIKit

public protocol CarouselTableViewCellDelegate: class {
    func carousel(cell: CarouselTableViewCell, didSelect imageUrlString: String)
}

public class CarouselTableViewCell: UITableViewCell {

    @IBOutlet weak var collectionView: UICollectionView!
    
    fileprivate var carouselImageUrlStrings = [String]()
    public weak var delegate: CarouselTableViewCellDelegate?

    override public func awakeFromNib() {
        super.awakeFromNib()
        collectionView.register(UINib(nibName: "ImageCollectionViewCell", bundle: Bundle.main), forCellWithReuseIdentifier: "ImageCollectionViewCell")
    }

    public func configureView(imageUrlStrings: [String]) {
        carouselImageUrlStrings = imageUrlStrings
        collectionView.reloadData()
    }
}

extension CarouselTableViewCell: UICollectionViewDataSource, UICollectionViewDelegate {
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return carouselImageUrlStrings.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageCollectionViewCell", for: indexPath) as? ImageCollectionViewCell ?? ImageCollectionViewCell()
        cell.configureView(imageUrlString: carouselImageUrlStrings[indexPath.row])
        return cell
    }
    
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate?.carousel(cell: self, didSelect: carouselImageUrlStrings[indexPath.row])
    }
}
