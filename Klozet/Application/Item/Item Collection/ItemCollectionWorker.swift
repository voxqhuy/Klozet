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
    
//    func imageFromCache(url: URL?) -> UIImage?
//    {
//        guard let url = url else { return nil }
////        if let data = Data(contentsOf: url) {
//            do {
//                let data = try Data(contentsOf: url)
//                return try NSKeyedUnarchiver.unarchivedObject(ofClass: UIImage.self, from: data)
//            }
//            catch { return nil }
////        } else {
////            return nil
////        }
//    }
}
