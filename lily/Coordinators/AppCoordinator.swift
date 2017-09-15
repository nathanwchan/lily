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
    
    required init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        navigationController.delegate = self
        
        self.showMainViewController()
    }

    private func showMainViewController() {
        let mainViewModel = MainViewModel()
        let mainViewController = MainViewController(viewModel: mainViewModel)
        mainViewModel.delegate = self
        self.navigationController.pushViewController(mainViewController, animated: false)
    }
}

extension AppCoordinator: MainViewModelDelegate {
    func mainViewDidClickCreateContest(_ mainViewModel: MainViewModel) {
        let createContestCoordinator = CreateContestCoordinator(navigationController: navigationController)
        createContestCoordinator.delegate = self
        createContestCoordinator.start()
        self.addChildCoordinator(createContestCoordinator)
    }
    
    func mainView(_ mainViewModel: MainViewModel, didSelectContest contest: Contest) {
        let viewContestCoordinator = ViewContestCoordinator(navigationController: navigationController, contest: contest)
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

extension AppCoordinator: CreateContestCoordinatorDelegate {
    func createContestCoordinatorDelegateDidCancel(_ createContestCoordinator: CreateContestCoordinator) {
        print("createContestCoordinatorDelegateDidCancel")
        createContestCoordinator.navigationController.popToRootViewController(animated: true)
        self.removeChildCoordinator(createContestCoordinator)
    }
    
    func createContestCoordinator(_ createContestCoordinator: CreateContestCoordinator, didCreateContest contest: Contest) {
        
        // do something with the Contest
        
        print("createContestCoordinator:didCreateContest \(contest.name)")
        createContestCoordinator.navigationController.popToRootViewController(animated: true)
        self.removeChildCoordinator(createContestCoordinator)
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
