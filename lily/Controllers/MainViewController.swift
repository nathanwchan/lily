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

class MainViewController: BaseViewModelViewController<MainViewModel> {
    
    let getMediaButton = UIButton(frame: .zero)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.initViewModel()
        
        view.backgroundColor = .white
        
        self.title = "contest.guru"
        
        let loginBarButtonItem = UIBarButtonItem(title: "Login", style: .plain, target: self, action: #selector(self.loginButtonClicked))
        self.navigationItem.rightBarButtonItem = loginBarButtonItem
        
        let stackView = UIStackView(frame: .zero)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.alignment = .fill
        stackView.isLayoutMarginsRelativeArrangement = true
        
        let spacing: CGFloat = 30
        
        stackView.spacing = spacing
        
        view.addSubview(stackView)
        
        stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: spacing).isActive = true
        stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -spacing).isActive = true
        stackView.topAnchor.constraint(equalTo: topLayoutGuide.bottomAnchor, constant: spacing).isActive = true
        stackView.bottomAnchor.constraint(equalTo: bottomLayoutGuide.topAnchor, constant: -spacing).isActive = true
        
        let createContestButton = UIButton(frame: .zero)
        createContestButton.center = view.center
        createContestButton.setTitle("Create Contest", for: .normal)
        createContestButton.backgroundColor = .blue
        createContestButton.addTarget(self, action: #selector(self.createContestButtonClicked(sender:)), for: .touchUpInside)
        
        stackView.addArrangedSubview(createContestButton)
        
        let viewContestButton = UIButton(frame: .zero)
        viewContestButton.center = view.center
        viewContestButton.setTitle("View Contest", for: .normal)
        viewContestButton.backgroundColor = .blue
        viewContestButton.addTarget(self, action: #selector(self.viewContestButtonClicked(sender:)), for: .touchUpInside)
        
        stackView.addArrangedSubview(viewContestButton)
        
        getMediaButton.center = view.center
        getMediaButton.setTitle("Get Media", for: .normal)
        getMediaButton.backgroundColor = .blue
        getMediaButton.addTarget(self, action: #selector(self.getMediaButtonClicked(sender:)), for: .touchUpInside)
        
        stackView.addArrangedSubview(getMediaButton)
    }
    
    private func initViewModel() {
        viewModel.didGetMediaForUser = { [weak self] in
            self?.viewModelDidGetMediaForUser()
        }
    }
    
    private func viewModelDidGetMediaForUser() {
        if let count = viewModel.media?.count {
            getMediaButton.setTitle("Media count: \(count)", for: .normal)
        }
    }
    
    func loginButtonClicked(sender: UIBarButtonItem) {
        viewModel.didClickLogin()
    }
    
    func createContestButtonClicked(sender: Any?) {
        viewModel.didClickCreateContest()
    }
    
    func viewContestButtonClicked(sender: UIButton) {
        
        // grab contest from dataSource/viewModel
        // TODO: just pass in index and have ViewModel grab Contest
        let contest = Contest(name: "viewContest", media: testMedia)
        
        viewModel.didSelectContest(contest)
    }
    
    func getMediaButtonClicked(sender: Any?) {
        viewModel.didClickGetMedia()
    }
}
