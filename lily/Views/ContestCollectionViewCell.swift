//
//  ContestCollectionViewCell.swift
//  lily
//
//  Created by Nathan Chan on 9/14/17.
//  Copyright © 2017 Nathan Chan. All rights reserved.
//

import UIKit

class ContestCollectionViewCell: UICollectionViewCell {
    
    var stackView: UIStackView!
    var imageView: UIImageView!
    static let buttonHeight: CGFloat = 25
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.clipsToBounds = true
        contentView.backgroundColor = .instagramLightGray
        
        stackView = UIStackView(frame: .zero)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.alignment = .fill
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.clipsToBounds = true
        stackView.spacing = 0
        
        contentView.addSubview(stackView)
        
        stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        stackView.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func configureWith(_ media: Media) {
        imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: contentView.bounds.width, height: contentView.bounds.height))
        imageView.contentMode = .scaleAspectFill
        imageView.image(fromUrl: media.imageUrl)
        
        stackView.addArrangedSubview(imageView)
    }
    
    func configureWith(_ contest: Contest, showCTA: Bool = false) {
        configureWith(contest.media)
        
        if showCTA {
            let label = UILabel()
            switch contest.state {
            case .Inactive:
                label.text = "Create Contest"
                label.textColor = .white
            case .InProgress:
                label.text = "\(arc4random_uniform(14))d left"
                label.textColor = .yellow
            case .Complete:
                label.text = "Complete"
                label.textColor = .green
            }
            label.font = UIFont(name: "HelveticaNeue", size: 14)
            label.backgroundColor = .instagramBlue
            label.textAlignment = .center
            
            label.heightAnchor.constraint(equalToConstant: ContestCollectionViewCell.buttonHeight).isActive = true
            label.widthAnchor.constraint(equalToConstant: contentView.bounds.width).isActive = true
            
            stackView.addArrangedSubview(label)
        }
    }
    
    override func prepareForReuse() {
        imageView.image = nil
        for subview in stackView.arrangedSubviews {
            stackView.removeArrangedSubview(subview)
            subview.removeFromSuperview()
        }
    }
}
