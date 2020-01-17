//
//  FAQWebViewController.swift
//  app-danceblue
//
//  Created by David Mercado on 11/8/19.
//  Copyright © 2019 DanceBlue. All rights reserved.
//

import Foundation
import UIKit
import WebKit

class FAQWebViewController: UIViewController, WKUIDelegate {
    
    var webView: WKWebView!
    
    override func loadView() {
        let webConfiguration = WKWebViewConfiguration()
        webView = WKWebView(frame: .zero, configuration: webConfiguration)
        webView.uiDelegate = self
        view = webView
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let myURL = URL(string:kFAQURL)
        let myRequest = URLRequest(url: myURL!)
        webView.load(myRequest)
    }}

