//
//  LoginViewController.swift
//  lily
//
//  Created by Nathan Chan on 9/15/17.
//  Copyright © 2017 Nathan Chan. All rights reserved.
//

import UIKit

class LoginViewController: BaseViewModelViewController<LoginViewModel> {
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .instagramBlue
        
        self.navigationItem.title = "Login"
        
        let loginButton = UIButton(frame: .zero)
        loginButton.setTitle("Fake Login", for: .normal)
        loginButton.setTitleColor(.instagramBlue, for: .normal)
        loginButton.backgroundColor = .white
        loginButton.addTarget(self, action: #selector(self.loginButtonClicked(sender:)), for: .touchUpInside)
        loginButton.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(loginButton)
        
        loginButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        loginButton.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        loginButton.widthAnchor.constraint(equalToConstant: 200).isActive = true
        loginButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
    }
    
    @objc func loginButtonClicked(sender: Any?) {
        viewModel.didClickSubmit()
    }
}
