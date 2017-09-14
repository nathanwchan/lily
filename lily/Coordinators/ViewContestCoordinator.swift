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
    var contest: Contest?
    var childCoordinators: [Coordinator] = []
    
    required init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    convenience init(navigationController: UINavigationController, contest: Contest) {
        self.init(navigationController: navigationController)
        self.contest = contest
    }
    
    func start() {
        self.showContestViewController()
    }
    
    fileprivate func showContestViewController() {
        let contestViewController = ContestViewController()
        contestViewController.delegate = self
        contestViewController.contest = contest
        self.navigationController.pushViewController(contestViewController, animated: true)
    }
    
    fileprivate func showResultsViewController() {
        let resultsViewController = ResultsViewController()
        resultsViewController.contest = contest
        self.navigationController.pushViewController(resultsViewController, animated: true)
    }
}

extension ViewContestCoordinator: ContestViewControllerDelegate {
    func contestViewController(_ contestViewController: ContestViewController, didClickSeeResults contest: Contest) {
        self.showResultsViewController()
    }
}
