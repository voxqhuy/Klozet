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

typealias FetchImageHandler = (FetchImageFirebaseResult) -> Void

class ItemCollectionWorker
{
    internal var fetchedResultsController: NSFetchedResultsController<Item> {
        let myCoreData = MyCoreData(modelName: "Klozet")
        
        let fetchRequest: NSFetchRequest<Item> = Item.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: #keyPath(Item.itemName), ascending: true)]
        
        return NSFetchedResultsController(
            fetchRequest: fetchRequest,
            managedObjectContext: myCoreData.managedContext,
            sectionNameKeyPath: nil,
            cacheName: nil)
    }
    
    internal func fechItemsFromFirebase() {
        
    }
    
    internal func imageForItem(_ item: Item) -> UIImage? {
        guard let itemId = item.itemId else { return nil }
        
        let imageUrl = FileManagerUtil().documentURL(forKey: "Item.\(itemId)")
        do {
            let imageData = try Data(contentsOf: imageUrl)
            return UIImage(data: imageData)
        } catch {
            return nil
        }
        
        
    }
    
    
//    func n() {
//        guard let itemId = item.itemId else { return }
//
//        imageFromFirebase(forItemId: itemId) { [weak self ](fetchImageResult) in
//            guard let self = self else { return }
//
//            switch fetchImageResult {
//            case .failure:
//                completion(.failure)
//            case let .success(image):
//                completion(.success(image))
//                self.saveNewImageToMemory(for: item, image: image)
//            }
//        }
//    }
    
    
    private func imageFromFirebase(forItemId itemId: String, completion: @escaping FetchImageHandler) {
        FirestoreUtil().item(withId: itemId).getDocument { (document, error) in
            
            if let document = document, document.exists {
                let imageUrl = document.data()!["imageUrl"] as! String
                // get Image with the url from Firebase Storage
                let imageRef = Storage.storage().reference(withPath: imageUrl)
                
                imageRef.getData(maxSize: 1 * 1024 * 1024) { data, error in
                    if error != nil {
                        completion(.failure)
                    } else {
                        completion(.success(UIImage(data: data!)!))
                    }
                }
            } else {
                completion(.failure)
                print("Document does not exist")
            }
        }
    }
    
    private func saveNewImageToMemory(for item: Item, image: UIImage) {
        // cache Image in Documents Directory
        let documentUrlForImage = FileManagerUtil().documentURL(forKey: "Item.\(String(describing: item.itemId))")
        do {
            try image.pngData()?.write(to: documentUrlForImage)
        } catch {}
    }
}
