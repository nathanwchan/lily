//
//  CreateContestSelectMediaViewController.swift
//  lily
//
//  Created by Nathan Chan on 10/12/17.
//  Copyright © 2017 Nathan Chan. All rights reserved.
//

import UIKit
import IGListKit

class CreateContestSelectMediaViewController: BaseViewModelViewController<CreateContestViewModel>, ListAdapterDataSource, IGListAdapterDelegate, MediaSectionControllerDelegate {
    
    lazy var adapter: ListAdapter = {
        return ListAdapter(updater: ListAdapterUpdater(), viewController: self, workingRangeSize: 0)
    }()
    
    private var mediaCollectionView: UICollectionView!
    private var loadingSpinner: UIActivityIndicatorView = UIActivityIndicatorView()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.initViewModel()
        
        view.backgroundColor = .white
        self.automaticallyAdjustsScrollViewInsets = false
        
        self.navigationItem.title = "Select an Instagram post"
        
        let cancelBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(self.cancelButtonTapped))
        self.navigationItem.rightBarButtonItem = cancelBarButtonItem
        
        let mediaCollectionViewLayout = ListCollectionViewLayout(stickyHeaders: false, scrollDirection: .vertical, topContentInset: 0, stretchToEdge: true)
        mediaCollectionView = UICollectionView(frame: view.bounds, collectionViewLayout: mediaCollectionViewLayout)
        mediaCollectionView.backgroundColor = .white
        mediaCollectionView.translatesAutoresizingMaskIntoConstraints = false
        
        adapter.collectionView = mediaCollectionView
        adapter.delegate = self
        adapter.dataSource = self
        
        view.addSubview(mediaCollectionView)
        
        mediaCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        mediaCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        mediaCollectionView.topAnchor.constraint(equalTo: topLayoutGuide.bottomAnchor).isActive = true
        mediaCollectionView.bottomAnchor.constraint(equalTo: bottomLayoutGuide.topAnchor).isActive = true
        
        loadingSpinner.center = view.center
        loadingSpinner.hidesWhenStopped = true
        loadingSpinner.activityIndicatorViewStyle = .whiteLarge
        loadingSpinner.color = .instagramBlue
        
        view.addSubview(loadingSpinner)
        
        loadingSpinner.startAnimating()
        
        viewModel.getMediaForUser()
    }
    
    private func initViewModel() {
        viewModel.didGetMediaForUser = { [weak self] in
            self?.viewModelDidGetMediaForUser()
        }
    }
    
    private func viewModelDidGetMediaForUser() {
        // TODO: if 0 in viewModel.media, show special view
        DispatchQueue.main.async {
            self.loadingSpinner.stopAnimating()
            self.adapter.performUpdates(animated: true)
        }
    }
    
    @objc func cancelButtonTapped(sender: UIBarButtonItem) {
        viewModel.didClickCancel()
    }
    
    // MARK: IGListKit delegate methods
    
    func objects(for listAdapter: ListAdapter) -> [ListDiffable] {
        return viewModel.media
    }
    
    func listAdapter(_ listAdapter: ListAdapter, sectionControllerFor object: Any) -> ListSectionController {
        let sectionController = MediaSectionController()
        sectionController.delegate = self
        return sectionController
    }
    
    func listAdapter(_ listAdapter: ListAdapter, willDisplay object: Any, at index: Int) {
        return
    }
    
    func listAdapter(_ listAdapter: ListAdapter, didEndDisplaying object: Any, at index: Int) {
        return
    }
    
    func emptyView(for listAdapter: ListAdapter) -> UIView? { return nil }
    
    // MARK: MediaSectionController delegate methods
    
    func mediaSectionController(_ mediaSectionController: MediaSectionController, didSelectMedia media: Media) {
        viewModel.didSelectMedia(media)
    }
}
