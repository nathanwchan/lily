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
    
    private var mediaCollectionView: UICollectionView!
    private let mediaCellReuseIdentifier = "mediaCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.initViewModel()
        
        view.backgroundColor = .white
        self.automaticallyAdjustsScrollViewInsets = false
        
        self.title = "contest.guru"
        
        let createContestButtonItem = UIBarButtonItem(title: "Create", style: .plain, target: self, action: #selector(self.createContestButtonClicked))
        self.navigationItem.leftBarButtonItem = createContestButtonItem
        
        let loginBarButtonItem = UIBarButtonItem(title: "Login", style: .plain, target: self, action: #selector(self.loginButtonClicked))
        self.navigationItem.rightBarButtonItem = loginBarButtonItem
        
        let flowLayout = UICollectionViewFlowLayout()
        let width = (view.bounds.width - 2) / 3
        flowLayout.itemSize = CGSize(width: width, height: width)
        flowLayout.minimumInteritemSpacing = 1
        flowLayout.minimumLineSpacing = 1
        
        mediaCollectionView = UICollectionView(frame: view.bounds, collectionViewLayout: flowLayout)
        mediaCollectionView.register(MediaCollectionViewCell.self, forCellWithReuseIdentifier: mediaCellReuseIdentifier)
        mediaCollectionView.delegate = self
        mediaCollectionView.dataSource = self
        mediaCollectionView.backgroundColor = .white
        mediaCollectionView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(mediaCollectionView)
        
        mediaCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        mediaCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        mediaCollectionView.topAnchor.constraint(equalTo: topLayoutGuide.bottomAnchor).isActive = true
        mediaCollectionView.bottomAnchor.constraint(equalTo: bottomLayoutGuide.topAnchor).isActive = true
        
        viewModel.getMedia()
    }
    
    private func initViewModel() {
        viewModel.didGetMediaForUser = { [weak self] in
            self?.viewModelDidGetMediaForUser()
        }
    }
    
    private func viewModelDidGetMediaForUser() {
        DispatchQueue.main.async {
            self.mediaCollectionView.reloadData()
        }
    }
    
    func loginButtonClicked(sender: UIBarButtonItem) {
        viewModel.didClickLogin()
    }
    
    func createContestButtonClicked(sender: Any?) {
        viewModel.didClickCreateContest()
    }
    
    //MARK: UICollectionView delegate methods
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.media?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let media = viewModel.media else {
            fatalError("no media loaded")
        }
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: mediaCellReuseIdentifier, for: indexPath) as! MediaCollectionViewCell
        cell.configureWith(media[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        viewModel.didSelectMedia(at: indexPath)
    }
}
