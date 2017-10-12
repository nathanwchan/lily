//
//  IGListItemSectionController.swift
//  lily
//
//  Created by Nathan Chan on 10/12/17.
//  Copyright © 2017 Nathan Chan. All rights reserved.
//

import Foundation
import IGListKit

protocol IGListItemSectionControllerDelegate: class {
    func iGListItemSectionController(_ iGListItemSectionController: IGListItemSectionController, didSelectIGListItem iGListItem: IGListItem)
}

class IGListItemSectionController: ListSectionController {
    var iGListItem: IGListItem!
    
    weak var delegate: IGListItemSectionControllerDelegate?
    
    override init() {
        super.init()
        
        self.inset = .init(top: 0, left: 0, bottom: 1, right: 1)
    }
    
    override func numberOfItems() -> Int {
        return 1
    }
    
    override func sizeForItem(at index: Int) -> CGSize {
        let width = (collectionContext!.containerSize.width - 2) / 3
        let height = width + ContestCollectionViewCell.buttonHeight
        return CGSize(width: width, height: height)
    }
    
    override func cellForItem(at index: Int) -> UICollectionViewCell {
        let cell = collectionContext!.dequeueReusableCell(of: IGListItemCollectionViewCell.self, for: self, at: index) as! IGListItemCollectionViewCell
        cell.configureWith(iGListItem)
        return cell
    }
    
    override func didUpdate(to object: Any) {
        iGListItem = object as? IGListItem
    }
    
    override func didSelectItem(at index: Int) {
        delegate?.iGListItemSectionController(self, didSelectIGListItem: iGListItem)
    }
}
