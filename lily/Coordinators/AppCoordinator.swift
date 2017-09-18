//
//  AppCoordinator.swift
//  lily
//
//  Created by Nathan Chan on 9/15/17.
//  Copyright © 2017 Nathan Chan. All rights reserved.
//

import UIKit

class AppCoordinator: NSObject, TabBarCoordinator {
    var tabBarController: UITabBarController
    var childCoordinators: [Coordinator] = []
    let publicTabNavigationController = UINavigationController()
    let profileTabNavigationController = UINavigationController()
    
    fileprivate var isLoggedIn = false
    
    required init(tabBarController: UITabBarController) {
        self.tabBarController = tabBarController
    }
    
    func start() {
        showLoggedInTabBarController()
    }
    
    fileprivate func initAndStartMainCoordinator(navigationController: UINavigationController, isLoggedIn: Bool = false) {
        let mainCoordinator = MainCoordinator(navigationController: navigationController, isLoggedIn: isLoggedIn)
        mainCoordinator.delegate = self
        mainCoordinator.start()
        self.addChildCoordinator(mainCoordinator)
    }
    
    fileprivate func initAndStartLoginCoordinator(navigationController: UINavigationController) {
        let loginCoordinator = LoginCoordinator(navigationController: navigationController)
        loginCoordinator.delegate = self
        loginCoordinator.start()
        self.addChildCoordinator(loginCoordinator)
    }
    
    fileprivate func showLoggedInTabBarController() {
        self.tabBarController.automaticallyAdjustsScrollViewInsets = false
        
        let publicTabBarItem = UITabBarItem(title: "Public", image: UIImage(named: "public-icon.png"), tag: 0)
        publicTabNavigationController.tabBarItem = publicTabBarItem
        
        let profileTabBarItem = UITabBarItem(title: "Profile", image: UIImage(named: "profile-icon.png"), tag: 1)
        profileTabNavigationController.tabBarItem = profileTabBarItem
        
        initAndStartMainCoordinator(navigationController: publicTabNavigationController)
        
        initAndStartLoginCoordinator(navigationController: profileTabNavigationController)
        
        tabBarController.viewControllers = [publicTabNavigationController, profileTabNavigationController]
    }
}

extension AppCoordinator: LoginCoordinatorDelegate {
    func loginCoordinatorDelegateDidLogin(_ loginCoordinator: LoginCoordinator) {
        self.isLoggedIn = true
        
        profileTabNavigationController.viewControllers = []
        self.removeChildCoordinator(loginCoordinator)
        
        initAndStartMainCoordinator(navigationController: profileTabNavigationController, isLoggedIn: isLoggedIn)
    }
}

extension AppCoordinator: MainCoordinatorDelegate {
    func mainCoordinateDelegateDidLogout(_ mainCoordinator: MainCoordinator) {
        self.isLoggedIn = false
        
        profileTabNavigationController.viewControllers = []
        self.removeChildCoordinator(mainCoordinator)
        
        initAndStartLoginCoordinator(navigationController: profileTabNavigationController)
        
        tabBarController.selectedIndex = 0
    }
}
