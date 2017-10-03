//
//  LoginWebViewController.swift
//  lily
//
//  Created by Nathan Chan on 10/2/17.
//  Copyright © 2017 Nathan Chan. All rights reserved.
//

import UIKit

protocol LoginWebViewControllerDelegate: class {
    func loginWebViewControllerDelegateDidCancel(_ loginWebViewController: LoginWebViewController)
    func loginWebViewControllerDelegateDidLogin(token: String)
}

class LoginWebViewController: UIViewController, UIWebViewDelegate {
    var url: URL!
    
    weak var delegate: LoginWebViewControllerDelegate?
    
    convenience init(url: URL) {
        self.init()
        self.url = url
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let navBar = UINavigationBar(frame: .zero)
        navBar.translatesAutoresizingMaskIntoConstraints = false
        let navItem = UINavigationItem(title: "Login")
        let cancelItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.cancel, target: nil, action: #selector(closeWebView))
        navItem.rightBarButtonItem = cancelItem
        navBar.setItems([navItem], animated: false)
        view.addSubview(navBar)
        
        navBar.topAnchor.constraint(equalTo: topLayoutGuide.bottomAnchor).isActive = true
        navBar.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        navBar.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        navBar.heightAnchor.constraint(equalToConstant: 44).isActive = true
        
        let webView = UIWebView(frame: .zero)
        webView.translatesAutoresizingMaskIntoConstraints = false
        webView.loadRequest(URLRequest(url: url))
        webView.delegate = self;
        view.addSubview(webView)
        
        webView.topAnchor.constraint(equalTo: navBar.bottomAnchor).isActive = true
        webView.bottomAnchor.constraint(equalTo: bottomLayoutGuide.topAnchor).isActive = true
        webView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        webView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
    }
    
    @objc func closeWebView() {
        self.delegate?.loginWebViewControllerDelegateDidCancel(self)
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        if let cookies = HTTPCookieStorage.shared.cookies {
            for cookie in cookies {
                if cookie.name == "token" {
                    self.delegate?.loginWebViewControllerDelegateDidLogin(token: cookie.value)
                    break
                }
            }
        }
    }
}
