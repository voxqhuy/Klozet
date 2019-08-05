//
//  MyController.swift
//  Klozet
//
//  Created by Huy Vo on 8/4/19.
//

import UIKit

enum MyStoryboard: String {
    case main = "Main"
    case outfit = "Outfit"
    case home = "Home"
    case item = "Item"
    var instance: UIStoryboard {
        return UIStoryboard(name: self.rawValue, bundle: nil)
    }
}

enum MyController: String {
    case itemCategoryCollectionViewController = "ItemCategoryCollectionViewController"
    case itemCollectionViewController = "ItemCollectionViewController"
    var instance: UIViewController {
        let storyboard: MyStoryboard
        switch self {
        case .itemCategoryCollectionViewController,
             .itemCollectionViewController:
            storyboard = MyStoryboard.item
        }
        return storyboard.instance.instantiateViewController(withIdentifier: self.rawValue)
    }
}
