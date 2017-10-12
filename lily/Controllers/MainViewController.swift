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

class MainViewController: BaseViewModelViewController<MainViewModel>, ListAdapterDataSource, IGListAdapterDelegate, ContestSectionControllerDelegate, IGListItemSectionControllerDelegate {
    
    lazy var adapter: ListAdapter = {
        return ListAdapter(updater: ListAdapterUpdater(), viewController: self, workingRangeSize: 0)
    }()
    
    private var contestsCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.initViewModel()
        
        view.backgroundColor = .white
        self.automaticallyAdjustsScrollViewInsets = false
        
        switch viewModel.pageType {
        case .public:
            self.navigationItem.title = "contest.guru"
        case .profile:
            self.navigationItem.title = "My Profile"
            let logoutBarButtonItem = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(self.logoutButtonClicked))
            self.navigationItem.rightBarButtonItem = logoutBarButtonItem
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
        
        switch viewModel.pageType {
        case .public:
            viewModel.getPublicContests()
        case .profile:
            viewModel.getContestsForUser()
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
        var items: [ListDiffable] = viewModel.contests
        if viewModel.pageType == .profile {
            items = [IGListItem(symbol: "+", text: "New") as ListDiffable] + items
        }
        return items
    }
    
    func listAdapter(_ listAdapter: ListAdapter, sectionControllerFor object: Any) -> ListSectionController {
        if let _ = object as? IGListItem {
            let sectionController = IGListItemSectionController()
            sectionController.delegate = self
            return sectionController
        } else {
            let sectionController = ContestSectionController(showCTA: viewModel.pageType == .profile)
            sectionController.delegate = self
            return sectionController
        }
    }
    
    func listAdapter(_ listAdapter: ListAdapter, willDisplay object: Any, at index: Int) {
        if index == viewModel.contests.count - 1 {
            switch viewModel.pageType {
            case .public:
                viewModel.getMorePublicContests()
            case .profile:
                viewModel.getMoreContestsForUser()
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
    
    // MARK: IGListItemSectionController delegate methods
    
    func iGListItemSectionController(_ iGListItemSectionController: IGListItemSectionController, didSelectIGListItem iGListItem: IGListItem) {
        viewModel.didClickCreateNewContest()
    }
}


