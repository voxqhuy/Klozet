//
//  ItemService.swift
//  Klozet
//
//  Created by Developers on 8/16/19.
//

import UIKit

struct ItemModel {
    let name: String
    let category: String
    let isFavorite: Bool
    let image: UIImage
}

struct ItemService {
    let itemModel: ItemModel
    
    init(itemModel: ItemModel) {
        self.itemModel = itemModel
    }
    
    private func saveItemToCoreData() {
        
    }
    
    private func saveItemToFirebase() {
        
    }
}
