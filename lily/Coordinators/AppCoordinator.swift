//
//  AppCoordinator.swift
//  lily
//
//  Created by Nathan Chan on 9/13/17.
//  Copyright © 2017 Nathan Chan. All rights reserved.
//

import UIKit

class AppCoordinator: NSObject, NavigationCoordinator {
    var navigationController: UINavigationController
    var childCoordinators: [Coordinator] = []
    
    fileprivate var isLoggedIn = false
    
    required init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        navigationController.delegate = self
        
        self.showMainViewController()
    }

    fileprivate func showMainViewController() {
        let mainViewModel = MainViewModel(isLoggedIn: isLoggedIn)
        let mainViewController = MainViewController(viewModel: mainViewModel)
        mainViewModel.delegate = self
        self.navigationController.pushViewController(mainViewController, animated: false)
    }
}

extension AppCoordinator: MainViewModelDelegate {
    func mainViewDidClickLogin(_ mainViewModel: MainViewModel) {
        let loginCoordinator = LoginCoordinator(navigationController: navigationController)
        loginCoordinator.delegate = self
        loginCoordinator.start()
        self.addChildCoordinator(loginCoordinator)
    }
    
    func mainViewDidClickLogout(_ mainViewModel: MainViewModel) {
        self.isLoggedIn = false
        
        self.navigationController.viewControllers = []
        self.showMainViewController()
    }
    
    func mainView(_ mainViewModel: MainViewModel, didSelectContest contest: Contest) {
        let viewContestCoordinator = ViewContestCoordinator(navigationController: navigationController, contest: contest, isLoggedIn: isLoggedIn)
        viewContestCoordinator.start()
        self.addChildCoordinator(viewContestCoordinator)
    }
    
    func mainView(_ mainViewModel: MainViewModel, didSelectMedia media: Media){
        let contest = Contest(name: "Contest Name", media: media)
        let viewContestCoordinator = ViewContestCoordinator(navigationController: navigationController, contest: contest)
        viewContestCoordinator.start()
        self.addChildCoordinator(viewContestCoordinator)
    }
}

extension AppCoordinator: LoginCoordinatorDelegate {
    func loginCoordinatorDelegateDidLogin(_ loginCoordinator: LoginCoordinator) {
        self.isLoggedIn = true
        
        self.navigationController.viewControllers = []
        self.removeChildCoordinator(loginCoordinator)
        self.showMainViewController()
    }
}

extension AppCoordinator: UINavigationControllerDelegate {
    // Handling back navigation from a sub-navigation-flow
    // http://khanlou.com/2017/05/back-buttons-and-coordinators/
    
    func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
        // ensure the view controller is popping
        guard
            let fromViewController = navigationController.transitionCoordinator?.viewController(forKey: .from),
            !navigationController.viewControllers.contains(fromViewController) else {
                return
        }
        
        // clean out ViewContestCoordinator from child coordinators
        if fromViewController is ContestViewController {
            childCoordinators = childCoordinators.filter { !($0.self is ViewContestCoordinator) }
        }
    }
}
