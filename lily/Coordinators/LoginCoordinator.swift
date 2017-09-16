//
//  LoginCoordinator.swift
//  lily
//
//  Created by Nathan Chan on 9/15/17.
//  Copyright © 2017 Nathan Chan. All rights reserved.
//

import UIKit

protocol LoginCoordinatorDelegate: class {
    func loginCoordinatorDelegateDidLogin(_ loginCoordinator: LoginCoordinator)
}

class LoginCoordinator: NavigationCoordinator {
    var navigationController: UINavigationController
    var childCoordinators: [Coordinator] = []
    
    weak var delegate: LoginCoordinatorDelegate?
    
    required init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        self.showLoginViewController()
    }
    
    fileprivate func showLoginViewController() {
        let loginViewModel = LoginViewModel()
        let loginViewController = LoginViewController(viewModel: loginViewModel)
        loginViewModel.delegate = self
        self.navigationController.pushViewController(loginViewController, animated: true)
    }
}

extension LoginCoordinator: LoginViewModelDelegate {
    func loginViewDidLoginSuccessfully(_ loginViewModel: LoginViewModel) {
        self.delegate?.loginCoordinatorDelegateDidLogin(self)
    }
}
