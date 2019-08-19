//
//  BusinessDetailsViewController.swift
//  Yelp Reviews
//
//  Created by Vineet Mrug on 2019-08-13.
//  Copyright © 2019 Vineet Mrug. All rights reserved.
//

import UIKit
import MBProgressHUD

class BusinessDetailsViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var viewModel: BusinessDetailsViewModel?
    
    static func initialize(business: YelpBusiness) -> BusinessDetailsViewController? {
        let controller = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "BusinessDetailsViewController") as? BusinessDetailsViewController
        if let businessId = business.id {
            controller?.viewModel = BusinessDetailsViewModel(businessId: businessId)
        }
        controller?.title = business.name
        return controller
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        loadData()
    }
    
    func configureView() {
        tableView.register(UINib(nibName: "CarouselTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: "CarouselTableViewCell")
        tableView.register(UINib(nibName: "ImageTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: "ImageTableViewCell")
        tableView.register(UINib(nibName: "BusinessDetailsTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: "BusinessDetailsTableViewCell")
        tableView.register(UINib(nibName: "ReviewTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: "ReviewTableViewCell")
    }
    
    func loadData() {
        tableView.isHidden = true
        MBProgressHUD.showAdded(to: view, animated: true)
        loadBusinessDetails()
        loadReviews()
    }
    
    func loadBusinessDetails() {
        viewModel?.getYelpBusinessDetails(completion: { [unowned self] error in
            DispatchQueue.main.async {
                if let viewModel = self.viewModel, viewModel.isDataLoadingComplete {
                    MBProgressHUD.hide(for: self.view, animated: true)
                    self.tableView.isHidden = false
                    self.tableView.reloadData()
                }
            }
        })
    }
    
    func loadReviews() {
        viewModel?.getReviews(completion: { [unowned self] error in
            DispatchQueue.main.async {
                if let viewModel = self.viewModel, viewModel.isDataLoadingComplete {
                    MBProgressHUD.hide(for: self.view, animated: true)
                    self.tableView.isHidden = false
                    self.tableView.reloadData()
                }
            }
        })
    }
    
    @objc func phoneNumberButtonTapped() {
        self.viewModel?.callBusiness()
    }
}

extension BusinessDetailsViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel?.tableViewSections.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let tableViewSection = viewModel?.tableViewSections[section]
        return tableViewSection?.getTableViewRows().count ?? 0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let tableViewSection = viewModel?.tableViewSections[indexPath.section]
        let tableViewRow = tableViewSection?.getTableViewRows()[indexPath.row]
        return tableViewRow?.getRowHeight(tableView: tableView) ?? 0
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let tableViewSection = viewModel?.tableViewSections[section]
        return tableViewSection?.title()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let tableViewSection = viewModel?.tableViewSections[indexPath.section]
        guard let tableViewRows = tableViewSection?.getTableViewRows() else { return UITableViewCell() }
        switch tableViewRows[indexPath.row] {
        case .mainImage:
            let cell = tableView.dequeueReusableCell(withIdentifier: "ImageTableViewCell") as? ImageTableViewCell ?? ImageTableViewCell()
            cell.configureView(imageUrlString: viewModel?.mainImageUrlString ?? viewModel?.business?.imageUrlString)
            return cell
        case .additionalImages:
            let cell = tableView.dequeueReusableCell(withIdentifier: "CarouselTableViewCell", for: indexPath) as? CarouselTableViewCell ?? CarouselTableViewCell()
            if let imageUrlStrings = viewModel?.business?.photos {
                cell.configureView(imageUrlStrings: imageUrlStrings)
                cell.delegate = self
            }
            return cell
        case .businessDetails:
            let cell = tableView.dequeueReusableCell(withIdentifier: "BusinessDetailsTableViewCell", for: indexPath) as? BusinessDetailsTableViewCell ?? BusinessDetailsTableViewCell()
            cell.configureView(business: viewModel?.business)
            cell.phoneNumberButton.addTarget(self, action: #selector(phoneNumberButtonTapped), for: .touchUpInside)
            return cell
        case .review:
            let cell = tableView.dequeueReusableCell(withIdentifier: "ReviewTableViewCell", for: indexPath) as? ReviewTableViewCell ?? ReviewTableViewCell()
            if let reviews = viewModel?.reviews {
                cell.configureView(review: reviews[indexPath.row])
            }
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard let tableViewSection = viewModel?.tableViewSections[indexPath.section] else { return }
        switch tableViewSection {
        case .reviews(let reviews):
            guard let reviewUrlString = reviews[indexPath.row].urlString else { return }
            if let webViewController = WebViewController.initialize(urlString: reviewUrlString) {
                navigationController?.pushViewController(webViewController, animated: true)
            }
        default:
            return
        }
    }
}

extension BusinessDetailsViewController: CarouselTableViewCellDelegate {
    func carousel(cell: CarouselTableViewCell, didSelect imageUrlString: String) {
        viewModel?.mainImageUrlString = imageUrlString
        tableView.reloadData()
    }
}
