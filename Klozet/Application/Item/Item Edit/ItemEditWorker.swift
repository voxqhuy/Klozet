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

enum SaveItemResult {
    case failure(String)
    case success
}

typealias SaveItemHandler = (SaveItemResult) -> Void

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
    
    func createItem(completion: @escaping SaveItemHandler) {
        var didInsertToCoreData = false
        var newItem = Item()
        
        insertItemToCoreData { (insertResult) in
            switch insertResult {
            case let .failure(errorString):
                completion(.failure(errorString))
            case let .success(insertedItem):
                newItem = insertedItem
                didInsertToCoreData = true
            }
        }
        
        if didInsertToCoreData {
            createItemOnFirebase { [weak self] (createResult) in
                guard let self = self else { return }
                
                switch createResult {
                case let .failure(errorString):
                    // fail to save item, delete it from Core Data
                    self.deleteItemFromCoreData(newItem)
                    completion(.failure(errorString))
                    
                case .success:
                    completion(.success)
                }
            }
        }
    }
    
    func updateItem() {
        var didUpdateInCoreData = false
        
        insertItemToCoreData { (insertResult) in
            switch insertResult {
            case let .failure(errorString):
                completion(.failure(errorString))
            case let .success(insertedItem):
                newItem = insertedItem
                didInsertToCoreData = true
            }
        }
        
        if didInsertToCoreData {
            createItemOnFirebase { [weak self] (createResult) in
                guard let self = self else { return }
                
                switch createResult {
                case let .failure(errorString):
                    // fail to save item, delete it from Core Data
                    self.deleteItemFromCoreData(newItem)
                    completion(.failure(errorString))
                    
                case .success:
                    completion(.success)
                }
            }
        }
    }
}


// Mark: - Core Data
extension ItemEditWorker {
    // MARK: Insert
    private func insertItemToCoreData(completion: InsertCoreDataHandler)
    {
        cacheImage { (cacheResult) in
            switch cacheResult {
            case let .failure(errorString):
                completion(.failure(errorString))
            case let .success(imageUrl):
                let insertedItem = insertItemAndReturn(into: managedContext, withImageUrl: imageUrl)
                completion(.success(insertedItem))
            }
        }
        
        myCoreData.saveContext()
    }
    
    private func cacheImage(completion: CacheHandler)
    {
        let imageUrl = FileManagerUtil().cachingURL(forKey: "Item.\(itemId)")
        do {
            try imageData.write(to: imageUrl)
            completion(.success(imageUrl))
        } catch {
            completion(.failure("Cannot cache the image"))
        }
    }
    
    private func insertItemAndReturn(into managedContext: NSManagedObjectContext, withImageUrl imageUrl: URL) -> Item
    {
        let item = NSEntityDescription.insertNewObject(forEntityName: coreDataEntity, into: managedContext) as! Item
        item.itemId = itemId
        item.itemName = itemModel.name
        item.category = itemModel.category
        item.isFavorite = itemModel.isFavorite // TODO make favorite button
        item.imageUrl = imageUrl
        return item
    }
    
    // MARK: Fetch
    private func itemFromCoreData() throws -> Item {
        let fetchRequest: NSFetchRequest<Item> = Item.fetchRequest()
        
        do {
            let items = try managedContext.fetch(fetchRequest)
            return items.first!
        } catch let error as NSError {
            throw error
        }
    }
    
    
    // MARK: Update
    private func updateItemInCoreData() throws {
        do {
            let editingItem = try itemFromCoreData()
            editingItem.itemName = itemModel.name
            editingItem.category = itemModel.category
            editingItem.isFavorite = itemModel.isFavorite
            
            myCoreData.saveContext()
        } catch let error as NSError {
            throw error
        }
    }
    
    // MARK: Delete
    private func deleteItemFromCoreData(_ item: Item) {
        managedContext.delete(item)
        
        myCoreData.saveContext()
    }
}


// MARK: - Firebase
extension ItemEditWorker {
    private func createItemOnFirebase(completion: @escaping SaveItemHandler)
    {
        uploadImageAndGetUrl { [weak self] (uploadImageResult) in
            guard let self = self else { return }
            
            switch uploadImageResult
            {
            case let .failure(errorString):
                completion(.failure(errorString))
                
            case let .success(imageUrl):
                // successfully uploaded the image and got url, now upload the item
                self.setItemOnFirebase(withImageUrl: imageUrl) { completion($0) }
            }
        }
    }
    
    private func uploadImageAndGetUrl(completion: @escaping UploadStorageHandler)
    {
        // Setup firebse storage to upload image
        let uploadRef = Storage.storage().reference(withPath: firebasePath)
        let uploadMetadata = StorageMetadata.init()
        uploadMetadata.contentType = "image/jpeg"
        
        // Start uploading
        uploadRef.putData(imageData, metadata: uploadMetadata) { (downloadMetadata, error) in
            if let error = error {
                completion(.failure("voxError. Fail to upload image. Description: \(error.localizedDescription)"))
                print()
            } else {
                completion(.success(downloadMetadata!.name!))
            }
        }
    }
    
    private func setItemOnFirebase(withImageUrl imageUrl: String, completion: @escaping SaveItemHandler) {
        
        firestoreUtil.item(withId: itemId).setData([
            "name": itemModel.name,
            "category": itemModel.category,
            "isFavorite": itemModel.isFavorite,
            "imageUrl": imageUrl
        ]) { err in
            if let err = err {
                completion(.failure("ERR saving item \(err)"))
            } else {
                completion(.success)
            }
        }
    }
}
