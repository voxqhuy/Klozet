//
//  MyError.swift
//  Klozet
//
//  Created by Developers on 8/21/19.
//

import Foundation

enum ItemError: Error {
    case failToFetchItemFromCoreData
    case failToCacheImage
    
    case failToUploadImageOnFirebase(String)
    case failToSetItemOnFirebase(String)
    case failToUpdateItemOnFirebase(String)
}

extension ItemError: CustomStringConvertible {
    var description: String {
        switch self {
        case .failToFetchItemFromCoreData:
            return "voxError. Fail to Fetch Item from Core Data."
        case .failToCacheImage:
            return "voxError. Fail to Cache Image."
        case let .failToUploadImageOnFirebase(errorString):
            return "voxError. Fail to Upload Image on Firebase. \(errorString)"
        case let .failToSetItemOnFirebase(errorString):
            return "voxError. Fail to Set Item on Firebase. \(errorString)"
        case let .failToUpdateItemOnFirebase(errorString):
            return "voxError. Fail to Update Item on Firebase. \(errorString)"
        }
        
    }
}
