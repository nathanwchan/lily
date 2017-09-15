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
        
        view.backgroundColor = .white
        view.clipsToBounds = true
        self.automaticallyAdjustsScrollViewInsets = false
        
        guard let contest = contest else {
            fatalError("No contest!")
        }
        
        self.title = contest.name
        
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
        
        let seeResultsButton = UIButton(frame: .zero)
        seeResultsButton.center = view.center
        seeResultsButton.setTitle("See Results", for: .normal)
        seeResultsButton.setTitleColor(.black, for: .normal)
        seeResultsButton.backgroundColor = .green
        seeResultsButton.addTarget(self, action: #selector(self.seeResultsButtonClicked(sender:)), for: .touchUpInside)
        
        detailStackView.addArrangedSubview(seeResultsButton)
    }
    
    func seeResultsButtonClicked(sender: Any?) {
        print("seeResultsButtonClicked")
        guard let contest = contest else {
            return
        }
        self.delegate?.contestViewController(self, didClickSeeResults: contest)
    }
}
