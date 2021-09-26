//
//  DetailVC.swift
//  AppBusterTest
//
//  Created by Денис Денисов on 24.09.2021.
//

import UIKit
import WebKit
import SnapKit

class DetailVC: UIViewController, WKUIDelegate {
    private let webView = WKWebView(frame: .zero)
    private let url: URL
    
    init(url: URL) {
        self.url = url
        super.init(nibName: nil, bundle: nil)
        let request = URLRequest(url: url)
        webView.load(request)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(webView)
        webView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
}
