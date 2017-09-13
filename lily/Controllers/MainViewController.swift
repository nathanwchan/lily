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

class MainViewController: UIViewController {
    
    weak var delegate: MainViewControllerDelegate?
    
    var childCoordinators: [Coordinator]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        self.title = "contest.guru"
        
        let loginBarButtonItem = UIBarButtonItem(title: "Login", style: .plain, target: self, action: #selector(self.loginButtonTapped))
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
    }
    
    func loginButtonTapped(sender: UIBarButtonItem) {
        print("loginButtonTapped")
    }
    
    func createContestButtonClicked(sender: Any?) {
        print("createContestButtonClicked")
        self.delegate?.mainViewControllerDidClickCreateContest(self)
    }
    
    func viewContestButtonClicked(sender: UIButton) {
        
        // grab contest from dataSource/viewModel
        let contest = Contest("viewContest")
        
        print("viewContestButtonClicked")
        self.delegate?.mainViewController(self, didSelectContest: contest)
    }
}
