//
//  FirestoreService.swift
//  Klozet
//
//  Created by Developers on 8/14/19.
//

import UIKit
import Firebase

struct FirestoreService {
    func uploadImageAndGetPath(for image: UIImage, withCategory category: String, completion: @escaping UploadStorageHandler) {
        let itemId = UUID.init().uuidString
        
        let uploadRef = Storage.storage().reference(withPath: "voxqhuy/Items/\(category)/\(itemId).jpg")
        
        guard let imageData = image.jpegData(compressionQuality: 0.75) else { return }
        let uploadMetadata = StorageMetadata.init()
        uploadMetadata.contentType = "image/jpeg"
        
        uploadRef.putData(imageData, metadata: uploadMetadata) { (downloadMetadata, error) in
            if let error = error {
                print("voxError \(error.localizedDescription)")
            } else {
                print("Put is complete and I got this back: \(String(describing: downloadMetadata))")
            }
        }
    }
}
