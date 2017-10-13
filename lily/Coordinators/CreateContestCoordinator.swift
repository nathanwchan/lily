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
    var createContestViewModel: CreateContestViewModel
    
    required init(navigationController: UINavigationController) {
        self.navigationController = navigationController
        createContestViewModel = CreateContestViewModel()
    }
    
    func start() {
        showCreateContestSelectMediaViewController()
    }
    
    private func showCreateContestSelectMediaViewController() {
        let createContestSelectMediaViewController = CreateContestSelectMediaViewController(viewModel: createContestViewModel)
        createContestViewModel.delegate = self
        self.navigationController.pushViewController(createContestSelectMediaViewController, animated: true)
    }
    
    fileprivate func showCreateContestViewController(_ media: Media) {
        let createContestViewController = CreateContestViewController(viewModel: createContestViewModel)
        createContestViewModel.delegate = self
        createContestViewModel.selectedMedia = media
        self.navigationController.pushViewController(createContestViewController, animated: true)
    }
}

extension CreateContestCoordinator: CreateContestViewModelDelegate {
    func createContestViewDidClickCancel(_ createContestViewModel: CreateContestViewModel) {
        self.delegate?.createContestCoordinatorDelegateDidCancel(self)
    }
    
    func createContestView(_ createContestViewModel: CreateContestViewModel, didSelectMedia media: Media) {
        showCreateContestViewController(media)
    }
    
    func createContestView(_ createContestViewModel: CreateContestViewModel, didCreateContest contest: Contest) {
        self.delegate?.createContestCoordinator(self, didCreateContest: contest)
    }
    
    func createContestView(_ createContestViewModel: CreateContestViewModel, didClickViewOnIG media: Media) {
        self.openMedia(media)
    }
}
