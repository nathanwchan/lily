//
//  CreateContestViewController.swift
//  lily
//
//  Created by Nathan Chan on 9/13/17.
//  Copyright © 2017 Nathan Chan. All rights reserved.
//

import UIKit

protocol CreateContestViewControllerDelegate: class {
    func createContestViewControllerDidTapCancel(_ createContestViewController: CreateContestViewController)
    func createContestViewController(_ createContestViewController: CreateContestViewController, didCreateContest contest: Contest)
}

class CreateContestViewController: UIViewController {
    
    weak var delegate: CreateContestViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .purple
        
        self.title = "Create a new contest"
        
        let cancelBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(self.cancelButtonTapped))
        self.navigationItem.leftBarButtonItem = cancelBarButtonItem
        
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
        createContestButton.setTitleColor(.black, for: .normal)
        createContestButton.backgroundColor = .yellow
        createContestButton.addTarget(self, action: #selector(self.createContestButtonClicked(sender:)), for: .touchUpInside)
        
        stackView.addArrangedSubview(createContestButton)
    }

    func cancelButtonTapped(sender: UIBarButtonItem) {
        print("cancelButtonTapped")
        self.delegate?.createContestViewControllerDidTapCancel(self)
    }

    func createContestButtonClicked(sender: Any?) {
        print("createContestButtonClicked")
        self.delegate?.createContestViewController(self, didCreateContest: Contest("createContest"))
    }
}
