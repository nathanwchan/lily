//
//  MainCoordinator.swift
//  lily
//
//  Created by Nathan Chan on 9/13/17.
//  Copyright © 2017 Nathan Chan. All rights reserved.
//

import UIKit

protocol MainCoordinatorDelegate: class {
    func mainCoordinatorDelegateDidLogout(_ mainCoordinator: MainCoordinator)
}

class MainCoordinator: NSObject, NavigationCoordinator {
    var navigationController: UINavigationController
    var childCoordinators: [Coordinator] = []
    
    weak var delegate: MainCoordinatorDelegate?
    
    var pageType: PageType!
    
    required init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    convenience init(navigationController: UINavigationController, pageType: PageType) {
        self.init(navigationController: navigationController)
        self.pageType = pageType
    }
    
    func start() {
        navigationController.delegate = self
        
        self.showMainViewController()
    }
    
    private func initMainViewController() -> MainViewController {
        let mainViewModel = MainViewModel(pageType: pageType)
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
        self.delegate?.mainCoordinatorDelegateDidLogout(self)
    }
    
    func mainViewDidClickCreateNewContest(_ mainViewModel: MainViewModel) {
        let createContestCoordinator = CreateContestCoordinator(navigationController: navigationController)
        createContestCoordinator.delegate = self
        createContestCoordinator.start()
        self.addChildCoordinator(createContestCoordinator)
    }
    
    func mainView(_ mainViewModel: MainViewModel, didSelectContest contest: Contest) {
        let viewContestCoordinator = ViewContestCoordinator(navigationController: navigationController, contest: contest, pageType: pageType)
        viewContestCoordinator.start()
        self.addChildCoordinator(viewContestCoordinator)
    }
    
    func mainView(_ mainViewModel: MainViewModel, didSelectMedia media: Media){
        let contest = Contest(name: "Contest Name", media: media)
        let viewContestCoordinator = ViewContestCoordinator(navigationController: navigationController, contest: contest, pageType: pageType)
        viewContestCoordinator.start()
        self.addChildCoordinator(viewContestCoordinator)
    }
}

extension MainCoordinator: CreateContestCoordinatorDelegate {
    func createContestCoordinatorDelegateDidCancel(_ createContestCoordinator: CreateContestCoordinator) {
        createContestCoordinator.navigationController.popToRootViewController(animated: true)
        self.removeChildCoordinator(createContestCoordinator)
    }
    
    func createContestCoordinator(_ createContestCoordinator: CreateContestCoordinator, didCreateContest contest: Contest) {
        createContestCoordinator.navigationController.popToRootViewController(animated: true)
        self.removeChildCoordinator(createContestCoordinator)
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
