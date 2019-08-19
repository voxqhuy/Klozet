//
//  WorkerHandlers.swift
//  Klozet
//
//  Created by Developers on 8/15/19.
//

import Foundation


// MARK: - File Manager
enum CacheResult {
    case failure(String)
    case success(URL)
}

typealias CacheHandler = (CacheResult) -> Void


// MARK: - Core Data
enum InsertCoreDataResult {
    case failure(String)
    case success(Item)
}

typealias InsertCoreDataHandler = (InsertCoreDataResult) -> Void


// MARK: - Firebase
enum SetFirebaseResult {
    case failure(String)
    case success
}

typealias SetFirebaseHandler = (SetFirebaseResult) -> Void

enum UploadStorageResult {
    case failure(String)
    case success(String)
}

typealias UploadStorageHandler = (UploadStorageResult) -> Void
