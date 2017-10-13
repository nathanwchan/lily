//
//  ViewContestCoordinator.swift
//  lily
//
//  Created by Nathan Chan on 9/13/17.
//  Copyright © 2017 Nathan Chan. All rights reserved.
//

import UIKit

class ViewContestCoordinator: NavigationCoordinator {
    var navigationController: UINavigationController
    var contest: Contest!
    var pageType: PageType!
    var childCoordinators: [Coordinator] = []
    
    required init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    convenience init(navigationController: UINavigationController, contest: Contest, pageType: PageType) {
        self.init(navigationController: navigationController)
        self.contest = contest
        self.pageType = pageType
    }
    
    func start() {
        self.showContestViewController()
    }
    
    fileprivate func showContestViewController() {
        guard let contest = contest else {
            return
        }
        let contestViewController = ContestViewController(contest: contest, pageType: pageType)
        contestViewController.delegate = self
        self.navigationController.pushViewController(contestViewController, animated: true)
    }
    
    fileprivate func showResultsViewController() {
        let resultsViewController = ResultsViewController()
        resultsViewController.contest = contest
        self.navigationController.pushViewController(resultsViewController, animated: true)
    }
}

extension ViewContestCoordinator: ContestViewControllerDelegate {
    func contestViewController(_ contestViewController: ContestViewController, didClickCreateContest contest: Contest) {
        let createContestCoordinator = CreateContestCoordinator(navigationController: navigationController)
        createContestCoordinator.delegate = self
        createContestCoordinator.start()
        self.addChildCoordinator(createContestCoordinator)
    }
    
    func contestViewController(_ contestViewController: ContestViewController, didClickSeeResults contest: Contest) {
        self.showResultsViewController()
    }
    
    func contestViewController(_ contestViewController: ContestViewController, didClickViewOnIG contest: Contest) {
        self.openMedia(contest.media)
    }
}

extension ViewContestCoordinator: CreateContestCoordinatorDelegate {
    func createContestCoordinatorDelegateDidCancel(_ createContestCoordinator: CreateContestCoordinator) {
        createContestCoordinator.navigationController.popToRootViewController(animated: true)
        self.removeChildCoordinator(createContestCoordinator)
    }
    
    func createContestCoordinator(_ createContestCoordinator: CreateContestCoordinator, didCreateContest contest: Contest) {
        createContestCoordinator.navigationController.popToRootViewController(animated: true)
        self.removeChildCoordinator(createContestCoordinator)
    }
}
