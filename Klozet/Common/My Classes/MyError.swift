//
//  MyError.swift
//  Klozet
//
//  Created by Developers on 8/21/19.
//

import Foundation

enum MyError: Error {
    // NOTE: if this enum gets long, divide it by grouping into category cases
    // E.g: case item(Item);    case outfit(Outfit)
    case failToFetchItemFromCoreData
    case failToCacheImage
    
    case failToUploadImageOnFirebase(String)
    case failToCreateItemOnFirebase(String)
    case failToUpdateItemOnFirebase(String)
}

extension MyError: CustomStringConvertible {
    var description: String {
        var errorDescription = "voxError. \(self) "
        switch self {
        case let .failToUploadImageOnFirebase(errorString),
             let .failToCreateItemOnFirebase(errorString),
             let .failToUpdateItemOnFirebase(errorString):
            errorDescription += errorString
        default:
            break
        }
        return errorDescription
    }
}
