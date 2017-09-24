//
//  MainViewController.swift
//  lily
//
//  Created by Nathan Chan on 9/13/17.
//  Copyright © 2017 Nathan Chan. All rights reserved.
//

import UIKit
import IGListKit

protocol MainViewControllerDelegate: class {
    func mainViewControllerDidClickCreateContest(_ mainViewController: MainViewController)
    func mainViewController(_ mainViewController: MainViewController, didSelectContest contest: Contest)
}

class MainViewController: BaseViewModelViewController<MainViewModel>, ListAdapterDataSource, IGListAdapterDelegate, ContestSectionControllerDelegate {
    
    lazy var adapter: ListAdapter = {
        return ListAdapter(updater: ListAdapterUpdater(), viewController: self, workingRangeSize: 0)
    }()
    
    private var contestsCollectionView: UICollectionView!
    private let contestCellReuseIdentifier = "contestCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.initViewModel()
        
        view.backgroundColor = .white
        self.automaticallyAdjustsScrollViewInsets = false
        
        if viewModel.isLoggedIn {
            self.navigationItem.title = "My Profile"
            let logoutBarButtonItem = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(self.logoutButtonClicked))
            self.navigationItem.rightBarButtonItem = logoutBarButtonItem
        } else {
            self.navigationItem.title = "contest.guru"
        }
        
        let contestsCollectionViewLayout = ListCollectionViewLayout(stickyHeaders: false, scrollDirection: .vertical, topContentInset: 0, stretchToEdge: true)
        contestsCollectionView = UICollectionView(frame: view.bounds, collectionViewLayout: contestsCollectionViewLayout)
        contestsCollectionView.backgroundColor = .white
        contestsCollectionView.translatesAutoresizingMaskIntoConstraints = false
        
        adapter.collectionView = contestsCollectionView
        adapter.delegate = self
        adapter.dataSource = self
        
        view.addSubview(contestsCollectionView)
        
        contestsCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        contestsCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        contestsCollectionView.topAnchor.constraint(equalTo: topLayoutGuide.bottomAnchor).isActive = true
        contestsCollectionView.bottomAnchor.constraint(equalTo: bottomLayoutGuide.topAnchor).isActive = true
        
        if viewModel.isLoggedIn {
            viewModel.getContestsForUser()
        } else {
            viewModel.getPublicContests()
        }
    }
    
    private func initViewModel() {
        viewModel.didGetContests = { [weak self] in
            self?.viewModelDidGetContests()
        }
    }
    
    private func viewModelDidGetContests() {
        DispatchQueue.main.async {
            self.adapter.performUpdates(animated: true)
        }
    }
    
    @objc func logoutButtonClicked(sender: UIBarButtonItem) {
        let alertController = UIAlertController(title: "Logout?", message: "Are you sure you want to logout?", preferredStyle: .alert)
        let logoutAction = UIAlertAction(title: "Yes", style: .default) { (_: UIAlertAction) -> Void in
            self.viewModel.didClickLogout()
        }
        let cancelAction = UIAlertAction(title: "No", style: .cancel) { (_: UIAlertAction) -> Void in }
        alertController.addAction(cancelAction)
        alertController.addAction(logoutAction)
        present(alertController, animated: true, completion: nil)
    }
    
    // MARK: IGListKit delegate methods
    
    func objects(for listAdapter: ListAdapter) -> [ListDiffable] {
        return viewModel.contests
    }
    
    func listAdapter(_ listAdapter: ListAdapter, sectionControllerFor object: Any) -> ListSectionController {
        let sectionController = ContestSectionController(isLoggedIn: viewModel.isLoggedIn)
        sectionController.delegate = self
        return sectionController
    }
    
    func listAdapter(_ listAdapter: ListAdapter, willDisplay object: Any, at index: Int) {
        if index == viewModel.contests.count - 1 {
            if viewModel.isLoggedIn {
                viewModel.getMoreContestsForUser()
            } else {
                viewModel.getMorePublicContests()
            }
        }
    }
    
    func listAdapter(_ listAdapter: ListAdapter, didEndDisplaying object: Any, at index: Int) {
        return
    }
    
    func emptyView(for listAdapter: ListAdapter) -> UIView? { return nil }
    
    // MARK: ContestSectionController delegate methods
    
    func contestSectionController(_ contestSectionController: ContestSectionController, didSelectContest contest: Contest) {
        viewModel.didSelectContest(contest)
    }
}


