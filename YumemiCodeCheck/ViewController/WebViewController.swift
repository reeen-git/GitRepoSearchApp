//
//  WebViewController.swift
//  iOSEngineerCodeCheck
//
//  Created by 高橋蓮 on 2022/06/05.
//  Copyright © 2022 YUMEMI Inc. All rights reserved.
//

import UIKit
import WebKit

class WebViewController: UIViewController {
    @IBOutlet weak var webView: WKWebView!
    
    var reciveUrl: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //webViewを読み込む
        guard let url = URL(string: reciveUrl) else { return }
        webView.load(URLRequest(url: url))
        webView.customUserAgent = "iPhone/Safari"
    }
    
}
