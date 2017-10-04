//
//  AppCoordinator.swift
//  lily
//
//  Created by Nathan Chan on 9/15/17.
//  Copyright © 2017 Nathan Chan. All rights reserved.
//

import UIKit

enum PageType {
    case `public`
    case profile
}

class AppCoordinator: NSObject, TabBarCoordinator {
    var tabBarController: UITabBarController
    var childCoordinators: [Coordinator] = []
    let publicTabNavigationController = UINavigationController()
    let profileTabNavigationController = UINavigationController()
    var checkedIfUserAlreadyLoggedIn = false
    
    required init(tabBarController: UITabBarController) {
        self.tabBarController = tabBarController
    }
    
    func start() {
        tabBarController.delegate = self
        initTabBarController()
    }
    
    fileprivate func initAndStartMainCoordinator(navigationController: UINavigationController, pageType: PageType) {
        let mainCoordinator = MainCoordinator(navigationController: navigationController, pageType: pageType)
        mainCoordinator.delegate = self
        mainCoordinator.start()
        self.addChildCoordinator(mainCoordinator)
    }
    
    fileprivate func initTabBarController() {
        self.tabBarController.automaticallyAdjustsScrollViewInsets = false
        
        let publicTabBarItem = UITabBarItem(title: "Public", image: UIImage(named: "public-icon.png"), tag: 0)
        publicTabNavigationController.tabBarItem = publicTabBarItem
        
        let profileTabBarItem = UITabBarItem(title: "Profile", image: UIImage(named: "profile-icon.png"), tag: 1)
        profileTabNavigationController.tabBarItem = profileTabBarItem
        
        initAndStartMainCoordinator(navigationController: publicTabNavigationController, pageType: .public)
        
        tabBarController.viewControllers = [publicTabNavigationController, profileTabNavigationController]
    }
}

extension AppCoordinator: UITabBarControllerDelegate {
    fileprivate func showLoginWebViewController() {
        let url = URL(string: "\(Globals.environment.rawValue)/login")
        if let url = url {
            if UIApplication.shared.canOpenURL(url) {
                let wvc = LoginWebViewController(url: url)
                wvc.delegate = self
                wvc.modalPresentationStyle = .overFullScreen
                self.tabBarController.present(wvc, animated: true, completion: nil)
            } else {
                let alertController = UIAlertController(title: "Error", message: "URL is invalid. Maybe it's missing http:// ?", preferredStyle: .alert)
                let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
                alertController.addAction(okAction)
                self.tabBarController.present(alertController, animated: true, completion: nil)
            }
        }
    }
    
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        if UserManager.shared.token == nil,
            viewController == tabBarController.viewControllers?[1] {
            // user is not logged in and Profile tab is selected
            showLoginWebViewController()
            return false
        } else if !checkedIfUserAlreadyLoggedIn {
            checkedIfUserAlreadyLoggedIn = true
            initAndStartMainCoordinator(navigationController: profileTabNavigationController, pageType: .profile)
        }
        return true
    }
}

extension AppCoordinator: LoginWebViewControllerDelegate {
    func loginWebViewControllerDelegateDidCancel(_ loginWebViewController: LoginWebViewController) {
        self.tabBarController.dismiss(animated: true, completion: nil)
    }
    
    func loginWebViewControllerDelegateDidLogin(token: String) {
        UserManager.shared.save(token)
        self.tabBarController.dismiss(animated: true, completion: nil)
        
        profileTabNavigationController.viewControllers = []
        
        initAndStartMainCoordinator(navigationController: profileTabNavigationController, pageType: .profile)
        
        tabBarController.selectedIndex = 1
    }
}

extension AppCoordinator: MainCoordinatorDelegate {
    func mainCoordinateDelegateDidLogout(_ mainCoordinator: MainCoordinator) {
        
        UserManager.shared.clearToken()
        let storage = HTTPCookieStorage.shared
        for cookie in storage.cookies! {
            storage.deleteCookie(cookie)
        }
        
        profileTabNavigationController.viewControllers = []
        self.removeChildCoordinator(mainCoordinator)
        
        tabBarController.selectedIndex = 0
    }
}
