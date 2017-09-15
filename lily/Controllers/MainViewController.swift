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
    
    var loggedIn: Bool = true
    private var contestsCollectionView: UICollectionView!
    private let contestCellReuseIdentifier = "contestCell"
    private let collectionViewCellButtonHeight: CGFloat = 25
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.initViewModel()
        
        view.backgroundColor = .white
        self.automaticallyAdjustsScrollViewInsets = false
        
        self.title = "contest.guru"
        
        let loginBarButtonItem = UIBarButtonItem(title: "Login", style: .plain, target: self, action: #selector(self.loginButtonClicked))
        self.navigationItem.rightBarButtonItem = loginBarButtonItem
        
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
        
        viewModel.getContests()
    }
    
    private func getContestsCollectionViewFlowLayout() -> UICollectionViewFlowLayout {
        let flowLayout = UICollectionViewFlowLayout()
        let width = (view.bounds.width - 2) / 3
        var height = width
        if loggedIn {
            height += collectionViewCellButtonHeight
        }
        flowLayout.itemSize = CGSize(width: width, height: height)
        flowLayout.minimumInteritemSpacing = 1
        flowLayout.minimumLineSpacing = 1
        return flowLayout
    }
    
    private func initViewModel() {
        viewModel.didGetContestsForUser = { [weak self] in
            self?.viewModelDidGetContestsForUser()
        }
    }
    
    private func viewModelDidGetContestsForUser() {
        DispatchQueue.main.async {
            self.contestsCollectionView.reloadData()
        }
    }
    
    func loginButtonClicked(sender: UIBarButtonItem) {
        viewModel.didClickLogin()
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
        cell.configureWith(contests[indexPath.row], showLabel: loggedIn, buttonHeight: collectionViewCellButtonHeight)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        viewModel.didSelectContest(at: indexPath)
    }
}
