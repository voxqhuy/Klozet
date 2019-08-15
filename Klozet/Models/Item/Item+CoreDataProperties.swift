//
//  Item+CoreDataProperties.swift
//  Klozet
//
//  Created by Developers on 8/15/19.
//
//

import Foundation
import CoreData


extension Item {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Item> {
        return NSFetchRequest<Item>(entityName: "Item")
    }

    @NSManaged public var category: String?
    @NSManaged public var imagePath: String?
    @NSManaged public var isFavorite: Bool
    @NSManaged public var itemName: String?

}
