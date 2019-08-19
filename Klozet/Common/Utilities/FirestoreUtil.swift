//
//  FirestoreUtil.swift
//  Klozet
//
//  Created by Developers on 8/19/19.
//

import Foundation
import FirebaseFirestore

class FirestoreUtil {
    let firestore = Firestore.firestore()
    
    func itemCollection() -> CollectionReference {
        return firestore.collection("users").document("voxqhuy").collection("items")
    }
    
    func item(withId itemId: String) -> DocumentReference {
        return itemCollection().document(itemId)
    }
}
