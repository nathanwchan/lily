//
//  MainViewController.swift
//  lily
//
//  Created by Nathan Chan on 9/13/17.
//  Copyright © 2017 Nathan Chan. All rights reserved.
//

import UIKit

protocol MainViewControllerDelegate: class {
    func mainViewControllerDidClickCreateContest(_ mainViewController: MainViewController)
    func mainViewController(_ mainViewController: MainViewController, didSelectContest contest: Contest)
}

class MainViewController: BaseViewModelViewController<MainViewModel>, UICollectionViewDelegate, UICollectionViewDataSource {
    
    private var contestsCollectionView: UICollectionView!
    private let contestCellReuseIdentifier = "contestCell"
    private let collectionViewCellButtonHeight: CGFloat = 25
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.initViewModel()
        
        view.backgroundColor = .white
        self.automaticallyAdjustsScrollViewInsets = false
        
        if viewModel.isLoggedIn {
            self.navigationItem.title = "Profile"
            let logoutBarButtonItem = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(self.logoutButtonClicked))
            self.navigationItem.rightBarButtonItem = logoutBarButtonItem
        } else {
            self.navigationItem.title = "Public"
        }
        
        contestsCollectionView = UICollectionView(frame: view.bounds, collectionViewLayout: getContestsCollectionViewFlowLayout())
        contestsCollectionView.register(ContestCollectionViewCell.self, forCellWithReuseIdentifier: contestCellReuseIdentifier)
        contestsCollectionView.delegate = self
        contestsCollectionView.dataSource = self
        contestsCollectionView.backgroundColor = .white
        contestsCollectionView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(contestsCollectionView)
        
        contestsCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        contestsCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        contestsCollectionView.topAnchor.constraint(equalTo: topLayoutGuide.bottomAnchor).isActive = true
        contestsCollectionView.bottomAnchor.constraint(equalTo: bottomLayoutGuide.topAnchor).isActive = true
        
        if viewModel.isLoggedIn {
            viewModel.getContests()
        } else {
            viewModel.getPublicContests()
        }
    }
    
    private func getContestsCollectionViewFlowLayout() -> UICollectionViewFlowLayout {
        let flowLayout = UICollectionViewFlowLayout()
        let width = (view.bounds.width - 2) / 3
        var height = width
        if viewModel.isLoggedIn {
            height += collectionViewCellButtonHeight
        }
        flowLayout.itemSize = CGSize(width: width, height: height)
        flowLayout.minimumInteritemSpacing = 1
        flowLayout.minimumLineSpacing = 1
        return flowLayout
    }
    
    private func initViewModel() {
        viewModel.didGetContests = { [weak self] in
            self?.viewModelDidGetContests()
        }
    }
    
    private func viewModelDidGetContests() {
        DispatchQueue.main.async {
            self.contestsCollectionView.reloadData()
        }
    }
    
    func logoutButtonClicked(sender: UIBarButtonItem) {
        let alertController = UIAlertController(title: "Logout?", message: "Are you sure you want to logout?", preferredStyle: .alert)
        let logoutAction = UIAlertAction(title: "Yes", style: .default) { (_: UIAlertAction) -> Void in
            self.viewModel.didClickLogout()
        }
        let cancelAction = UIAlertAction(title: "No", style: .cancel) { (_: UIAlertAction) -> Void in }
        alertController.addAction(cancelAction)
        alertController.addAction(logoutAction)
        present(alertController, animated: true, completion: nil)
    }
    
    //MARK: UICollectionView delegate methods
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.contests?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let contests = viewModel.contests else {
            fatalError("no contests loaded")
        }
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: contestCellReuseIdentifier, for: indexPath) as! ContestCollectionViewCell
        cell.configureWith(contests[indexPath.row], showLabel: viewModel.isLoggedIn, buttonHeight: collectionViewCellButtonHeight)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        viewModel.didSelectContest(at: indexPath)
    }
}
