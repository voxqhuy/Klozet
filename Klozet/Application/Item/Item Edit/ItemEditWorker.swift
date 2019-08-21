//
//  ItemEditWorker.swift
//  Klozet
//
//  Created by Huy Vo on 8/18/19.
//

import UIKit
import CoreData
import Firebase

struct ItemModel {
    let name: String
    let category: String
    let isFavorite: Bool
    let image: UIImage
}

class ItemEditWorker {
    let itemModel: ItemModel!
    private let itemId: String
    private let imageData: Data
    private let myCoreData: MyCoreData
    private let managedContext: NSManagedObjectContext
    private lazy var firestoreUtil = FirestoreUtil()
    
    private let coreDataEntity = "Item"
    private var firebasePath: String {
        return "voxqhuy/Items/\(itemModel.category)/\(itemId).jpg"
    }
    
    init?(itemModel: ItemModel, itemId: String? = nil)
    {
        guard let imageData = itemModel.image.jpegData(compressionQuality: 0.75) else { return nil }
        self.imageData = imageData
        
        self.itemModel = itemModel
        self.itemId = (itemId != nil) ? itemId! : UUID().uuidString
        
        myCoreData = MyCoreData(modelName: "Klozet")
        managedContext = myCoreData.managedContext
    }
    
    func createItem(completion: @escaping CreateItemHandler)
    {
        createItemOnFirebase { [weak self] (createResult) in
            guard let self = self else { return }
            
            switch createResult {
            case let .failure(error):
                completion(.failure(error))
                
            case .success:
                do {
                    // successfully create on firebase, now Core Data
                    let imageUrl = try self.cacheImageAndReturnUrl()
                    self.insertItem(withImageUrl: imageUrl)
                    completion(.success)
                } catch {
                    completion(.failure(error as! ItemError))
                }
            }
        }
    }
    
    func updateItem(completion: @escaping UpdateItemHandler)
    {
        updateItemOnFirebase { [weak self] (createResult) in
            guard let self = self else { return }
            
            switch createResult {
            case let .failure(error):
                completion(.failure(error))
                
            case .success:
                do {
                    // successfully update on firebase, now Core Data
                    try self.updateItemOnCoreData()
                    completion(.success)
                } catch {
                    completion(.failure(error as! ItemError))
                }
            }
        }
    }
}

// MARK: - File Manager
extension ItemEditWorker {
    private func cacheImageAndReturnUrl() throws -> URL
    {
        let imageUrl = FileManagerUtil().cachingURL(forKey: "Item.\(itemId)")
        do {
            try imageData.write(to: imageUrl)
            return imageUrl
        } catch {
            throw ItemError.failToCacheImage
        }
    }
}

// Mark: - Core Data
extension ItemEditWorker {
    // INSERT
    private func insertItem(withImageUrl imageUrl: URL)
    {
        let item = NSEntityDescription.insertNewObject(forEntityName: coreDataEntity, into: managedContext) as! Item
        item.itemId = itemId
        item.itemName = itemModel.name
        item.category = itemModel.category
        item.isFavorite = itemModel.isFavorite // TODO make favorite button
        item.imageUrl = imageUrl
        
        myCoreData.saveContext()
    }
    
    // FETCH
    private func itemFromCoreData() throws -> Item {
        let fetchRequest: NSFetchRequest<Item> = Item.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "itemId == %@", itemId)
        
        do {
            let items = try managedContext.fetch(fetchRequest)
            return items.first!
        } catch {
            throw ItemError.failToFetchItemFromCoreData
        }
    }
    
    
    // UPDATE
    private func updateItemOnCoreData() throws {
        do {
            let editingItem = try itemFromCoreData()
            editingItem.itemName = itemModel.name
            editingItem.category = itemModel.category
            editingItem.isFavorite = itemModel.isFavorite
            
            myCoreData.saveContext()
        } catch {
            throw error
        }
    }
    
    // MARK: Delete
//    private func deleteItemFromCoreData(_ item: Item)
//    {
//        managedContext.delete(item)
//        myCoreData.saveContext()
//    }
}


// MARK: - Firebase
extension ItemEditWorker {
    // Firebase Storage
    private func createItemOnFirebase(completion: @escaping CreateItemHandler)
    {
        // Setup firebse storage to upload image
        let uploadRef = Storage.storage().reference(withPath: firebasePath)
        let uploadMetadata = StorageMetadata.init()
        uploadMetadata.contentType = "image/jpeg"
        
        // Start uploading
        uploadRef.putData(imageData, metadata: uploadMetadata) { [weak self] (downloadMetadata, error) in
            guard let self = self else { return }
            
            if let error = error {
                completion(.failure(ItemError.failToUploadImageOnFirebase(error.localizedDescription)))
            } else {
                let imageUrl = downloadMetadata!.name!
                // successfully uploaded the image and got url, now upload the item
                self.setItemOnFirebase(withImageUrl: imageUrl) { completion($0) }
            }
        }
    }
    
    // SET
    private func setItemOnFirebase(withImageUrl imageUrl: String, completion: @escaping CreateItemHandler)
    {
        firestoreUtil.item(withId: itemId).setData([
            "name": itemModel.name,
            "category": itemModel.category,
            "isFavorite": itemModel.isFavorite,
            "imageUrl": imageUrl
        ]) { err in
            if let err = err {
                completion(.failure(ItemError.failToSetItemOnFirebase(err.localizedDescription)))
            } else {
                completion(.success)
            }
        }
    }
    
    // UPDATE
    private func updateItemOnFirebase(completion: @escaping UpdateItemHandler)
    {
        firestoreUtil.item(withId: itemId).updateData([
            "name": itemModel.name,
            "category": itemModel.category,
            "isFavorite": itemModel.isFavorite
        ]) { err in
            if let err = err {
                completion(.failure(ItemError.failToSetItemOnFirebase(err.localizedDescription)))
            } else {
                completion(.success)
            }
        }
    }
}
