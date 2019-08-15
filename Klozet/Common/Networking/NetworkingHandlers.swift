//
//  NetworkingHandlers.swift
//  Klozet
//
//  Created by Developers on 8/15/19.
//

import Foundation

enum UploadStorageResult {
    case failure(String)
    case success(String)
}

typealias UploadStorageHandler = (UploadStorageResult) -> Void
