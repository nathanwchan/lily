//
//  MediaCollectionViewCell.swift
//  lily
//
//  Created by Nathan Chan on 9/14/17.
//  Copyright © 2017 Nathan Chan. All rights reserved.
//

import UIKit

class MediaCollectionViewCell: UICollectionViewCell {
    
    var imageView: UIImageView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.clipsToBounds = true
        
        imageView = UIImageView(frame: contentView.bounds)
        imageView.contentMode = .scaleAspectFill
        
        contentView.addSubview(imageView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func configureWith(_ media: Media) {
        imageView.image(fromUrl: media.imageUrl)
        
    }
}
