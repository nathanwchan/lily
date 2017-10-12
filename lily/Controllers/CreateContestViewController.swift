//
//  CreateContestViewController.swift
//  lily
//
//  Created by Nathan Chan on 9/13/17.
//  Copyright © 2017 Nathan Chan. All rights reserved.
//

import UIKit

class CreateContestViewController: BaseViewModelViewController<CreateContestViewModel> {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .instagramBlue
        
        self.navigationItem.title = "Create a new contest"
        
        let cancelBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(self.cancelButtonTapped))
        self.navigationItem.rightBarButtonItem = cancelBarButtonItem
        
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
        createContestButton.setTitleColor(.instagramBlue, for: .normal)
        createContestButton.backgroundColor = .white
        createContestButton.addTarget(self, action: #selector(self.createContestButtonClicked(sender:)), for: .touchUpInside)
        
        stackView.addArrangedSubview(createContestButton)
    }

    @objc func cancelButtonTapped(sender: UIBarButtonItem) {
        viewModel.didClickCancel()
    }

    @objc func createContestButtonClicked(sender: Any?) {
        viewModel.didClickCreateNewContest()
    }
}
