//
//  NetworkingHandlers.swift
//  Klozet
//
//  Created by Developers on 8/15/19.
//

import Foundation

enum CacheResult {
    case failure(String)
    case success(URL)
}

typealias CacheHandler = (CacheResult) -> Void


enum SaveCoreDataResult {
    case failure(String)
    case success
}

typealias SaveCoreDataHandler = (SaveCoreDataResult) -> Void


enum UploadStorageResult {
    case failure(String)
    case success(String)
}

typealias UploadStorageHandler = (UploadStorageResult) -> Void
