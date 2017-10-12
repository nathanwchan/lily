//
//  MediaSectionController.swift
//  lily
//
//  Created by Nathan Chan on 10/12/17.
//  Copyright © 2017 Nathan Chan. All rights reserved.
//

import Foundation
import IGListKit

protocol MediaSectionControllerDelegate: class {
    func mediaSectionController(_ mediaSectionController: MediaSectionController, didSelectMedia media: Media)
}

class MediaSectionController: ListSectionController {
    var media: Media!
    
    weak var delegate: MediaSectionControllerDelegate?
    
    override init() {
        super.init()
        
        self.inset = .init(top: 0, left: 0, bottom: 1, right: 1)
    }
    
    override func numberOfItems() -> Int {
        return 1
    }
    
    override func sizeForItem(at index: Int) -> CGSize {
        let width = (collectionContext!.containerSize.width - 2) / 3
        return CGSize(width: width, height: width)
    }
    
    override func cellForItem(at index: Int) -> UICollectionViewCell {
        let cell = collectionContext!.dequeueReusableCell(of: ContestCollectionViewCell.self, for: self, at: index) as! ContestCollectionViewCell
        cell.configureWith(media)
        return cell
    }
    
    override func didUpdate(to object: Any) {
        media = object as? Media
    }
    
    override func didSelectItem(at index: Int) {
        self.delegate?.mediaSectionController(self, didSelectMedia: media)
    }
}
