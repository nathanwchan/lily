//
//  LoginViewModel.swift
//  lily
//
//  Created by Nathan Chan on 9/15/17.
//  Copyright © 2017 Nathan Chan. All rights reserved.
//

import Foundation

protocol LoginViewModelDelegate: class {
    func loginViewDidLoginSuccessfully(_ loginViewModel: LoginViewModel)
}

enum LoginError {
    case Unknown
}

class LoginViewModel {
    
    weak var delegate: LoginViewModelDelegate?
    
    init() {}
    
    //MARK: - Events
    
    var didFailLogin: ((LoginError) -> Void)?
    
    //MARK: - Private
    
    private func didFailLogin(with error: LoginError) {
        self.didFailLogin?(error)
    }
    
    //MARK: - Actions
    
    func didClickSubmit() {
        self.delegate?.loginViewDidLoginSuccessfully(self)
    }
}
