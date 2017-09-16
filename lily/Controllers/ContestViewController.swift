//
//  ContestViewController.swift
//  lily
//
//  Created by Nathan Chan on 9/13/17.
//  Copyright © 2017 Nathan Chan. All rights reserved.
//

import UIKit

protocol ContestViewControllerDelegate: class {
    func contestViewController(_ contestViewController: ContestViewController, didClickCreateContest contest: Contest)
    func contestViewController(_ contestViewController: ContestViewController, didClickSeeResults contest: Contest)
    func contestViewController(_ contestViewController: ContestViewController, didClickViewOnIG contest: Contest)
}

class ContestViewController: UIViewController {

    weak var delegate: ContestViewControllerDelegate?
    
    var contest: Contest?
    var isLoggedIn: Bool?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        view.clipsToBounds = true
        self.automaticallyAdjustsScrollViewInsets = false
        
        guard let contest = contest else {
            fatalError("No contest!")
        }
        
        if let isLoggedIn = isLoggedIn, isLoggedIn,
            contest.state != .Inactive {
            self.title = contest.name
        } else {
            self.title = contest.media.type.capitalized
        }
        
        let scrollView = UIScrollView(frame: .zero)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.keyboardDismissMode = .onDrag
        scrollView.alwaysBounceVertical = true
        
        view.addSubview(scrollView)
        
        scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        scrollView.topAnchor.constraint(equalTo: topLayoutGuide.bottomAnchor).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: bottomLayoutGuide.topAnchor).isActive = true

        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: view.bounds.width))
        imageView.contentMode = .scaleAspectFit
        imageView.image(fromUrl: contest.media.imageUrl, readjustFrameSize: true)
        
        imageView.setContentHuggingPriority(UILayoutPriorityDefaultHigh, for: .vertical)
        
        scrollView.addSubview(imageView)
        
        let spacing: CGFloat = 20
        
        let detailStackView = UIStackView(frame: .zero)
        detailStackView.translatesAutoresizingMaskIntoConstraints = false
        detailStackView.axis = .vertical
        detailStackView.distribution = .fill
        detailStackView.alignment = .fill
        detailStackView.isLayoutMarginsRelativeArrangement = true
        detailStackView.clipsToBounds = true
        detailStackView.spacing = spacing
        
        scrollView.addSubview(detailStackView)
        
        detailStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: spacing).isActive = true
        detailStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -spacing).isActive = true
        detailStackView.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: spacing).isActive = true
        detailStackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -spacing).isActive = true
        
        if let isLoggedIn = isLoggedIn, isLoggedIn {
            let actionButton = UIButton(frame: .zero)
            actionButton.center = view.center
            switch contest.state {
            case .Inactive:
                actionButton.setTitle("Create Contest", for: .normal)
                actionButton.setTitleColor(.white, for: .normal)
                actionButton.backgroundColor = .instagramBlue
            case .InProgress:
                actionButton.setTitle("Contest currently in progress!", for: .normal)
                actionButton.setTitleColor(.black, for: .normal)
                actionButton.backgroundColor = .white
            case .Complete:
                actionButton.setTitle("See Results", for: .normal)
                actionButton.setTitleColor(.white, for: .normal)
                actionButton.backgroundColor = .instagramBlue
            }
            actionButton.addTarget(self, action: #selector(self.actionButtonClicked(sender:)), for: .touchUpInside)
            
            detailStackView.addArrangedSubview(actionButton)
        }
        
        let captionLabel = UILabel(frame: .zero)
        let attrs: [String: AnyObject] = [NSFontAttributeName: UIFont(name: "HelveticaNeue-Bold", size: 14)!]
        let attributedString = NSMutableAttributedString(string: contest.media.username, attributes: attrs)
        
        if let caption = contest.media.caption {
            let attrs: [String: AnyObject] = [NSFontAttributeName: UIFont(name: "HelveticaNeue", size: 14)!]
            attributedString.append(NSMutableAttributedString(string: " \(caption)", attributes: attrs))
        }
        
        captionLabel.attributedText = attributedString
        captionLabel.textColor = .black
        captionLabel.textAlignment = .left
        captionLabel.numberOfLines = 0
        
        detailStackView.addArrangedSubview(captionLabel)
        
        let viewOnIGButton = UIButton(frame: .zero)
        viewOnIGButton.center = view.center
        viewOnIGButton.setTitle("View on Instagram", for: .normal)
        viewOnIGButton.setTitleColor(.white, for: .normal)
        viewOnIGButton.backgroundColor = .instagramBlue
        viewOnIGButton.addTarget(self, action: #selector(self.viewOnIGButtonClicked(sender:)), for: .touchUpInside)
        
        detailStackView.addArrangedSubview(viewOnIGButton)
    }
    
    func actionButtonClicked(sender: Any?) {
        guard let contest = contest else {
            return
        }
        switch contest.state {
        case .Inactive:
            self.delegate?.contestViewController(self, didClickCreateContest: contest)
        case .InProgress:
            break
        case .Complete:
            self.delegate?.contestViewController(self, didClickSeeResults: contest)
        }
    }
    
    func viewOnIGButtonClicked(sender: Any?) {
        guard let contest = contest else {
            return
        }
        self.delegate?.contestViewController(self, didClickViewOnIG: contest)
    }
}
