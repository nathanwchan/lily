//
//  ContestSectionController.swift
//  lily
//
//  Created by Nathan Chan on 9/24/17.
//  Copyright © 2017 Nathan Chan. All rights reserved.
//

import Foundation
import IGListKit

protocol ContestSectionControllerDelegate: class {
    func contestSectionController(_ contestSectionController: ContestSectionController, didSelectContest contest: Contest)
}

class ContestSectionController: ListSectionController {
    var contest: Contest!
    var isLoggedIn: Bool!
    
    weak var delegate: ContestSectionControllerDelegate?
    
    init(isLoggedIn: Bool) {
        super.init()
        
        self.isLoggedIn = isLoggedIn
        self.inset = .init(top: 0, left: 0, bottom: 1, right: 1)
    }
    
    override func numberOfItems() -> Int {
        return 1
    }
    
    override func sizeForItem(at index: Int) -> CGSize {
        let width = (collectionContext!.containerSize.width - 2) / 3
        var height = width
        if isLoggedIn {
            height += ContestCollectionViewCell.buttonHeight
        }
        return CGSize(width: width, height: height)
    }
    
    override func cellForItem(at index: Int) -> UICollectionViewCell {
        let cell = collectionContext!.dequeueReusableCell(of: ContestCollectionViewCell.self, for: self, at: index) as! ContestCollectionViewCell
        cell.configureWith(contest, showLabel: isLoggedIn)
        return cell
    }
    
    override func didUpdate(to object: Any) {
        contest = object as? Contest
    }
    
    override func didSelectItem(at index: Int) {
        delegate?.contestSectionController(self, didSelectContest: contest)
    }
}
