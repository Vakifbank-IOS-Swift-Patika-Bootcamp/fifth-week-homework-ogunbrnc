//
//  IMDBViewController.swift
//  BreakingBad
//
//  Created by Ogün Birinci on 23.11.2022.
//

import UIKit
import WebKit

final class IMDBViewController: UIViewController,WKNavigationDelegate {
    //MARK: UI Components
    var webView: WKWebView!
    
    //MARK: Life Cycle Methods
    override func loadView() {
        webView = WKWebView()
        webView.navigationDelegate = self
        view = webView
    }

    // MARK: Configure WebView
    private func configureWebView() {
        let urlString = "https://www.imdb.com/title/tt0903747/episodes"
        if let url = URL(string: urlString) {
            webView.navigationDelegate = self
            webView.load(URLRequest(url: url))
        }
        let refresh = UIBarButtonItem(barButtonSystemItem: .refresh, target: webView, action: #selector(webView.reload))
        toolbarItems = [refresh]
        navigationController?.isToolbarHidden = false
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        configureWebView()
    }
   
}
