//
//  MainCoordinator.swift
//  lily
//
//  Created by Nathan Chan on 9/13/17.
//  Copyright © 2017 Nathan Chan. All rights reserved.
//

import UIKit

protocol MainCoordinatorDelegate: class {
    func mainCoordinateDelegateDidLogout(_ mainCoordinator: MainCoordinator)
}

class MainCoordinator: NSObject, NavigationCoordinator {
    var navigationController: UINavigationController
    var childCoordinators: [Coordinator] = []
    
    weak var delegate: MainCoordinatorDelegate?
    
    fileprivate var isLoggedIn = false
    
    required init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    convenience init(navigationController: UINavigationController, isLoggedIn: Bool = false) {
        self.init(navigationController: navigationController)
        self.isLoggedIn = isLoggedIn
    }
    
    func start() {
        navigationController.delegate = self
        
        self.showMainViewController()
    }
    
    private func initMainViewController() -> MainViewController {
        let mainViewModel = MainViewModel(isLoggedIn: isLoggedIn)
        let mainViewController = MainViewController(viewModel: mainViewModel)
        mainViewModel.delegate = self
        return mainViewController
    }

    fileprivate func showMainViewController() {
        self.navigationController.pushViewController(initMainViewController(), animated: false)
    }
}

extension MainCoordinator: MainViewModelDelegate {
    func mainViewDidClickLogout(_ mainViewModel: MainViewModel) {
        self.delegate?.mainCoordinateDelegateDidLogout(self)
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

extension MainCoordinator: LoginCoordinatorDelegate {
    func loginCoordinatorDelegateDidLogin(_ loginCoordinator: LoginCoordinator) {
        self.isLoggedIn = true
        
        self.navigationController.viewControllers = []
        self.removeChildCoordinator(loginCoordinator)
        self.showMainViewController()
    }
}

extension MainCoordinator: UINavigationControllerDelegate {
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
