//
//  ItemCollectionWorker.swift
//  Klozet
//
//  Created by Developers on 8/22/19.
//

import UIKit
import CoreData
import FirebaseStorage

enum FetchImageFirebaseResult {
    case failure
    case success(UIImage)
}

typealias FetchImageFirebaseHandler = (FetchImageFirebaseResult) -> Void

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
    
//    internal func imageForItem(_ item: Item) -> UIImage? {
//        if let image = UIImage(contentsOfFile: item.imageUrl?.path ?? "") {
//            return image
//        } else {
//            let image = imageFromFirebase(forItemId: item.itemId)
//            cacheNewImage(for: item)
//        }
//    }
//    
//    private func imageFromFirebase(forItemId itemId: String, completion: @escaping FetchImageFirebaseHandler) {
//        FirestoreUtil().item(withId: itemId).getDocument { [weak self] (document, error) in
//            guard let self = self else { return }
//            
//            if let document = document, document.exists {
////                let
//                let imageUrl = document.data()!["imageUrl"] as! String
//                // TODO
//                // TODO imageFromFirebaseStorage
//            } else {
//                completion(.failure)
//                print("Document does not exist")
//            }
//        }
//    }
//    
//    private func imageFromFirebaseStorage(completion: @escaping FetchImageFirebaseHandler) {
//        let imageRef = Storage.reference("url")
//    
//        islandRef.getData(maxSize: 1 * 1024 * 1024) { data, error in
//        if let error = error {
//        // Uh-oh, an error occurred!
//        } else {
//        // Data for "images/island.jpg" is returned
//        let image = UIImage(data: data!)
//        }
//        }
//    }
    
    private func cacheNewImage(for item: Item) {
        // caches directory? or documents, maybe documents
    }
}
