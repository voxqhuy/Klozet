//
//  ItemCollectionWorker.swift
//  Klozet
//
//  Created by Developers on 8/22/19.
//

import UIKit
import CoreData

struct ItemCollectionWorker
{
//    private let itemId: String
//    
//    init(itemId: String) {
//        self.itemId = itemId
//    }
    
    var fetchedResultsController: NSFetchedResultsController<Item> {
        let myCoreData = MyCoreData(modelName: "Klozet")
        
        let fetchRequest: NSFetchRequest<Item> = Item.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: #keyPath(Item.itemName), ascending: true)]
        
        return NSFetchedResultsController(
            fetchRequest: fetchRequest,
            managedObjectContext: myCoreData.managedContext,
            sectionNameKeyPath: nil,
            cacheName: nil)
    }
    
    func imageFromCache(url: URL) -> UIImage?
    {
        if let data = NSData(contentsOf: url) {
            do {
                return try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data as Data) as? UIImage
            }
            catch {}
        }
    }
}
