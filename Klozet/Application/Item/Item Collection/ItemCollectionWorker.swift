//
//  ItemCollectionWorker.swift
//  Klozet
//
//  Created by Developers on 8/22/19.
//

import Foundation
import CoreData

struct ItemCollectionWorker
{
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
    
    
}
