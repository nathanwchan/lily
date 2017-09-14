//
//  CreateContestCoordinator.swift
//  lily
//
//  Created by Nathan Chan on 9/13/17.
//  Copyright © 2017 Nathan Chan. All rights reserved.
//

import UIKit

protocol CreateContestCoordinatorDelegate: class {
    func createContestCoordinatorDelegateDidCancel(_ createContestCoordinator: CreateContestCoordinator)
    func createContestCoordinator(_ createContestCoordinator: CreateContestCoordinator, didCreateContest contest: Contest)
}

class CreateContestCoordinator: NavigationCoordinator {
    var navigationController: UINavigationController
    var childCoordinators: [Coordinator] = []
    
    weak var delegate: CreateContestCoordinatorDelegate?
    
    required init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        self.showCreateContestViewController()
    }
    
    private func showCreateContestViewController() {
        let createContestViewController = CreateContestViewController()
        createContestViewController.delegate = self
        self.navigationController.pushViewController(createContestViewController, animated: true)
    }
}

extension CreateContestCoordinator: CreateContestViewControllerDelegate {
    func createContestViewControllerDidTapCancel(_ createContestViewController: CreateContestViewController) {
        self.delegate?.createContestCoordinatorDelegateDidCancel(self)
    }
    
    func createContestViewController(_ createContestViewController: CreateContestViewController, didCreateContest contest: Contest) {
        self.delegate?.createContestCoordinator(self, didCreateContest: contest)
    }
}
