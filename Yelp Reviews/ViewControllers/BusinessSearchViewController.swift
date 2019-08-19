//
//  BusinessSearchViewController.swift
//  Yelp Reviews
//
//  Created by Vineet Mrug on 2019-08-13.
//  Copyright © 2019 Vineet Mrug. All rights reserved.
//

import UIKit
import MBProgressHUD

class BusinessSearchViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var sortDescriptionLabel: UILabel!
    @IBOutlet weak var placeholderLabel: UILabel!
    @IBOutlet weak var sortBarButtonItem: UIBarButtonItem!
    
    let viewModel = BusinessSearchViewModel()
    let searchController = UISearchController(searchResultsController: nil)

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        refreshResults(searchTerm: "Indian")
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        configureCollectionView()
    }
    
    fileprivate func configureView() {
        let titleImageView = UIImageView(image: UIImage(named: "Yelp_logo"))
        titleImageView.contentMode = .scaleAspectFit
        titleImageView.frame = CGRect(x: 0, y: -6, width: 170, height: 50)
        let titleView = UIView(frame: titleImageView.bounds)
        titleView.addSubview(titleImageView)
        titleView.backgroundColor = .clear
        self.navigationItem.titleView = titleView

        configureSearchController()
    }

    fileprivate func configureSearchController() {
        searchController.searchBar.delegate = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.searchBar.placeholder = "Search Yelp Businesses"
        searchController.searchBar.tintColor = .white
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        definesPresentationContext = true
    }
    
    fileprivate func configureCollectionView() {
        if let flowLayout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            let padding: CGFloat = 10
            let collectionViewItemAspectRatio: CGFloat = 1.25
            let itemWidth = (collectionView.frame.width - (3 * padding))/2
            let itemHeight = itemWidth/collectionViewItemAspectRatio
            flowLayout.itemSize = CGSize(width: itemWidth, height: itemHeight)
            flowLayout.sectionInset = UIEdgeInsets(top: padding, left: padding, bottom: padding, right: padding)
            flowLayout.minimumInteritemSpacing = padding
            flowLayout.minimumLineSpacing = padding
        }
    }
    
    func refreshResults(searchTerm: String? = nil) {
        guard let searchTerm = searchTerm ?? searchController.searchBar.text else { return }
        searchController.searchBar.text = searchTerm
        MBProgressHUD.showAdded(to: view, animated: true)
        viewModel.searchYelpBusinesses(searchTerm: searchTerm, completion: { [unowned self] errorMessage in
            DispatchQueue.main.async {
                self.sortDescriptionLabel.text = "Sorted by: \(self.viewModel.sortMode.descriptionString())"
                self.collectionView.reloadData()
                self.togglePlaceholder(self.viewModel.businesses.isEmpty)
                MBProgressHUD.hide(for: self.view, animated: true)
            }
            if let errorMessage = errorMessage {
                print("Search error: \(errorMessage)")
            }
        })
    }
    
    func togglePlaceholder(_ shouldShow: Bool) {
        placeholderLabel.text = "Sorry! We couldn't find any results based on your search."
        placeholderLabel.isHidden = !shouldShow
        sortBarButtonItem.isEnabled = !shouldShow
        sortDescriptionLabel.isHidden = shouldShow
    }
    
    @IBAction func sortBarButtonTapped(_ sender: Any) {
        let sortResultsActionSheet = UIAlertController(title: "Sort by", message: nil, preferredStyle: .actionSheet)
        let distanceAction = UIAlertAction(title: BusinessSortMode.distance.descriptionString(), style: .default, handler: { [unowned self] _ in
            self.viewModel.sortMode = .distance
            self.refreshResults()
        })
        let ratingAction = UIAlertAction(title: BusinessSortMode.rating.descriptionString(), style: .default, handler: { [unowned self] _ in
            self.viewModel.sortMode = .rating
            self.refreshResults()
        })
        let reviewCountAction = UIAlertAction(title: BusinessSortMode.reviewCount.descriptionString(), style: .default, handler: { [unowned self] _ in
            self.viewModel.sortMode = .reviewCount
            self.refreshResults()
        })
        let bestMatchAction = UIAlertAction(title: BusinessSortMode.bestMatch.descriptionString(), style: .default, handler: { [unowned self] _ in
            self.viewModel.sortMode = .bestMatch
            self.refreshResults()
        })
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        sortResultsActionSheet.addAction(bestMatchAction)
        sortResultsActionSheet.addAction(ratingAction)
        sortResultsActionSheet.addAction(reviewCountAction)
        sortResultsActionSheet.addAction(distanceAction)
        sortResultsActionSheet.addAction(cancelAction)
        present(sortResultsActionSheet, animated: true, completion: nil)
    }
    
    func presentBusinessDetails(business: YelpBusiness) {
        if let businessDetailsViewController = BusinessDetailsViewController.initialize(business: business) {
            navigationController?.pushViewController(businessDetailsViewController, animated: true)
        }
    }
}

extension BusinessSearchViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        refreshResults()
    }
}

extension BusinessSearchViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.businesses.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "YelpBusinessCollectionViewCell", for: indexPath) as? YelpBusinessCollectionViewCell ?? YelpBusinessCollectionViewCell()
        cell.configureView(business: viewModel.businesses[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        searchController.searchBar.endEditing(true)
        let selectedBusiness = viewModel.businesses[indexPath.row]
        presentBusinessDetails(business: selectedBusiness)
    }
}

extension BusinessSearchViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        searchController.searchBar.endEditing(true)
    }
}
