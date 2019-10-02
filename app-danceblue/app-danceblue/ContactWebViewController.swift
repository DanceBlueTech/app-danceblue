//
//  ContactWebViewController.swift
//  app-danceblue
//
//  Created by David Mercado on 10/1/19.
//  Copyright © 2019 DanceBlue. All rights reserved.
//

import Foundation
import UIKit
import WebKit
class ContactWebViewController: UIViewController, WKUIDelegate {
    
    var webView: WKWebView!
    //var webView: UIWebView!
    
    override func loadView() {
        let webConfiguration = WKWebViewConfiguration()
        webView = WKWebView(frame: .zero, configuration: webConfiguration)
        webView.uiDelegate = self
        view = webView
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let myURL = URL(string:kContactInfoURL)
        let myRequest = URLRequest(url: myURL!)
        webView.load(myRequest)
    }}
