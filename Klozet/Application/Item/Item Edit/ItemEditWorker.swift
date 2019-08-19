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

struct ItemEditWorker {
    let itemModel: ItemModel!
    private let itemId: String
    private let imageData: Data
    private let coreDataEntity = "Item"
    
    init?(itemModel: ItemModel) {
        self.itemModel = itemModel

        itemId = UUID().uuidString
        guard let imageData = itemModel.image.jpegData(compressionQuality: 0.75) else { return nil }
        self.imageData = imageData
    }
    
    func saveItem(completion: SaveItemHandler) {
        saveItemToCoreData { (saveCoreDataResult) in
            <#code#>
        }
        
        saveItemToFirebase()
    }
}


// Mark: - Core Data
extension ItemEditWorker {
    private func saveItemToCoreData(completion: SaveCoreDataHandler) {
        let myCoreData = MyCoreData(modelName: "Klozet")
        let managedContext = myCoreData.managedContext
        
        cacheImage { (cacheResult) in
            switch cacheResult {
            case let .failure(errorString):
                completion(.failure(errorString))
            case let .success(imageUrl):
                insertItem(into: managedContext, withImageUrl: imageUrl)
            }
        }
        
        myCoreData.saveContext()
        //try! managedContext.save()
    }
    
    private func cacheImage(completion: CacheHandler) {
        let imageUrl = FileManagerUtil().cachingURL(forKey: "Item.\(itemId)")
        do {
            try imageData.write(to: imageUrl)
            completion(.success(imageUrl))
        } catch {
            completion(.failure("Cannot cache the image"))
        }
    }
    
    private func insertItem(into managedContext: NSManagedObjectContext, withImageUrl imageUrl: URL) {
        let item = NSEntityDescription.insertNewObject(forEntityName: coreDataEntity, into: managedContext) as! Item
        item.itemId = itemId
        item.itemName = itemModel.name
        item.category = itemModel.category
        item.isFavorite = itemModel.isFavorite // TODO make favorite button
        item.imageUrl = imageUrl
    }
}


// MARK: - Firebase
extension ItemEditWorker {
    
    
    
    private func saveItemToFirebase() {
        
    }
    
    func uploadImageAndGetPath(for image: UIImage, withCategory category: String, completion: @escaping UploadStorageHandler) {
        let itemId = UUID.init().uuidString
        
        let uploadRef = Storage.storage().reference(withPath: "voxqhuy/Items/\(category)/\(itemId).jpg")
        
        guard let imageData = image.jpegData(compressionQuality: 0.75) else { return }
        let uploadMetadata = StorageMetadata.init()
        uploadMetadata.contentType = "image/jpeg"
        
        uploadRef.putData(imageData, metadata: uploadMetadata) { (downloadMetadata, error) in
            if let error = error {
                completion(.failure("voxError. Fail to upload image. Description: \(error.localizedDescription)"))
                print()
            } else {
                completion(.success(downloadMetadata!.name!))
            }
        }
    }
}
