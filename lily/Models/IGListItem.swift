//
//  IGListItem.swift
//  lily
//
//  Created by Nathan Chan on 10/12/17.
//  Copyright © 2017 Nathan Chan. All rights reserved.
//

import Foundation
import IGListKit

class IGListItem: ListDiffable {
    var symbol: String
    var text: String
    
    init(symbol: String, text: String) {
        self.symbol = symbol
        self.text = text
    }
    
    func diffIdentifier() -> NSObjectProtocol {
        return self.symbol as NSObjectProtocol
    }
    
    func isEqual(toDiffableObject object: ListDiffable?) -> Bool {
        guard self !== object else { return true }
        guard let object = object as? IGListItem else { return false }
        return symbol == object.symbol
    }
}
