//
//  Item+CoreDataProperties.swift
//  Klozet
//
//  Created by Huy Vo on 8/18/19.
//
//

import Foundation
import CoreData


extension Item {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Item> {
        return NSFetchRequest<Item>(entityName: "Item")
    }

    @NSManaged public var category: String?
    @NSManaged public var imageUrl: URL?
    @NSManaged public var isFavorite: Bool
    @NSManaged public var itemName: String?
    @NSManaged public var itemId: String?

}
