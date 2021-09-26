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
    
    var webView: WKWebView!
    let backButton: UIButton = {
        let button = UIButton(type: .system) as UIButton
        button.addTarget(self, action: #selector(backPressed), for: .touchUpInside)
        button.setTitle("back", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 30)
        button.backgroundColor = .darkText
        button.layer.cornerRadius = 15
        button.layer.borderWidth = 1
        button.tintColor = .white
        return button
    }()
    
    
    
    override func loadView() {
        let webConfig = WKWebViewConfiguration()
        webView = WKWebView(frame:.zero, configuration: webConfig)
        webView.uiDelegate = self
        view = webView
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        let url = URL(string: "https://gist.github.com/3918167a5daaf7098b15c812ae6107d2")!
        let request = URLRequest(url: url)
        
        webView.load(request)
        view.addSubview(backButton)
        
        backButton.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.size.equalToSuperview().multipliedBy(0.2)
        }
        
        
        
        
        
    }
    @objc func backPressed(sender: UIButton!) {
        if(webView.canGoBack) {
            //Go back in webview history
            webView.goBack()
        } else {
            print(111)
        }
    }
    
    
    
    
    
}
