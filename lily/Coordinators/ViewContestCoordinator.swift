//
//  ViewContestCoordinator.swift
//  lily
//
//  Created by Nathan Chan on 9/13/17.
//  Copyright © 2017 Nathan Chan. All rights reserved.
//

import UIKit
import SafariServices

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
    
    fileprivate func openUrlInModal(_ url: URL?) {
        if let url = url {
            if UIApplication.shared.canOpenURL(url) {
                let vc = SFSafariViewController(url: url, entersReaderIfAvailable: false)
                vc.modalPresentationStyle = .overFullScreen
                self.navigationController.present(vc, animated: true, completion: nil)
            } else {
                let alertController = UIAlertController(title: "Error", message: "URL is invalid. Maybe it's missing http:// ?", preferredStyle: .alert)
                let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
                alertController.addAction(okAction)
                self.navigationController.present(alertController, animated: true, completion: nil)
            }
        }
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
        self.openUrlInModal(URL(string: contest.media.link))
    }
}

extension ViewContestCoordinator: CreateContestCoordinatorDelegate {
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
