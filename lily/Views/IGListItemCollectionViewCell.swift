//
//  IGListItemCollectionViewCell.swift
//  lily
//
//  Created by Nathan Chan on 10/12/17.
//  Copyright © 2017 Nathan Chan. All rights reserved.
//

import UIKit

class IGListItemCollectionViewCell: UICollectionViewCell {
    
    var stackView: UIStackView!
    
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
    
    func configureWith(_ iGListItem: IGListItem) {
        for subview in stackView.arrangedSubviews {
            stackView.removeArrangedSubview(subview)
            subview.removeFromSuperview()
        }
        
        let symbolLabel = UILabel(frame: CGRect(x: 0, y: 0, width: contentView.bounds.width, height: contentView.bounds.height))
        symbolLabel.text = iGListItem.symbol
        symbolLabel.textColor = .instagramBlue
        symbolLabel.font = UIFont(name: "HelveticaNeue", size: 70)
        symbolLabel.backgroundColor = .white
        symbolLabel.textAlignment = .center
        
        stackView.addArrangedSubview(symbolLabel)
        
        let label = UILabel()
        label.text = iGListItem.text
        label.textColor = .white
        label.font = UIFont(name: "HelveticaNeue", size: 14)
        label.backgroundColor = .instagramBlue
        label.textAlignment = .center
        
        label.heightAnchor.constraint(equalToConstant: ContestCollectionViewCell.buttonHeight).isActive = true
        label.widthAnchor.constraint(equalToConstant: contentView.bounds.width).isActive = true
        
        stackView.addArrangedSubview(label)
    }
}
