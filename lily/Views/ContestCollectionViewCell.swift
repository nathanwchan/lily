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
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.clipsToBounds = true
        
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
        
        imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: contentView.bounds.width, height: contentView.bounds.height))
        imageView.contentMode = .scaleAspectFill
        
        stackView.addArrangedSubview(imageView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func configureWith(_ contest: Contest, showLabel: Bool = false, buttonHeight: CGFloat = 0) {
        imageView.image(fromUrl: contest.media.imageUrl)
        
        if showLabel {
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
            label.backgroundColor = UIColor(red: 0.22, green: 0.59, blue: 0.94, alpha: 1.0)
            label.textAlignment = .center
            
            label.heightAnchor.constraint(equalToConstant: buttonHeight).isActive = true
            label.widthAnchor.constraint(equalToConstant: contentView.bounds.width).isActive = true
            
            stackView.addArrangedSubview(label)
        }
    }
}
