//
//  WebViewController.swift
//  Yelp Reviews
//
//  Created by Vineet Mrug on 2019-08-16.
//  Copyright © 2019 Vineet Mrug. All rights reserved.
//

import UIKit
import WebKit
import MBProgressHUD

class WebViewController: UIViewController {

    @IBOutlet weak var webView: WKWebView!
    
    fileprivate var urlString: String?
    
    static func initialize(urlString: String) -> WebViewController? {
        let controller = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "WebViewController") as? WebViewController
        controller?.urlString = urlString
        return controller
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
    }
    
    func configureView() {
        webView.navigationDelegate = self
        guard let urlString = urlString, let url = URL(string: urlString) else { return }
        MBProgressHUD.showAdded(to: view, animated: true)
        webView.load(URLRequest(url: url))
    }
}

extension WebViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        MBProgressHUD.hide(for: view, animated: true)
    }
}
