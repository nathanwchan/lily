//
//  ContestViewController.swift
//  lily
//
//  Created by Nathan Chan on 9/13/17.
//  Copyright © 2017 Nathan Chan. All rights reserved.
//

import UIKit

protocol ContestViewControllerDelegate: class {
    func contestViewController(_ contestViewController: ContestViewController, didClickSeeResults contest: Contest)
}

class ContestViewController: UIViewController {

    weak var delegate: ContestViewControllerDelegate?
    
    var contest: Contest?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .red
        
        self.title = "View contest"
        
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
        
        let seeResultsButton = UIButton(frame: .zero)
        seeResultsButton.center = view.center
        seeResultsButton.setTitle("See Results", for: .normal)
        seeResultsButton.setTitleColor(.black, for: .normal)
        seeResultsButton.backgroundColor = .green
        seeResultsButton.addTarget(self, action: #selector(self.seeResultsButtonClicked(sender:)), for: .touchUpInside)
        
        stackView.addArrangedSubview(seeResultsButton)
    }
    
    func seeResultsButtonClicked(sender: Any?) {
        print("seeResultsButtonClicked")
        guard let contest = contest else {
            return
        }
        self.delegate?.contestViewController(self, didClickSeeResults: contest)
    }
}
