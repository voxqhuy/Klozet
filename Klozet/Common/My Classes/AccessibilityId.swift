//
//  AccessibilityId.swift
//  Klozet
//
//  Created by Huy Vo on 8/4/19.
//

import Foundation

enum AccessibilityId {
    // Item Category Collection VC
    case itemCategoryCollectionView
    
    // Item Collection VC
    case addItemActionSheet
    
    var description: String {
        return String(describing: self)
    }
}
