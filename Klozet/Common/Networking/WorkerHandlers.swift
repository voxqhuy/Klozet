//
//  WorkerHandlers.swift
//  Klozet
//
//  Created by Developers on 8/15/19.
//

import Foundation

// MARK: - Item
enum CreateItemResult {
    case failure(ItemError)
    case success
}

typealias CreateItemHandler = (CreateItemResult) -> Void

enum UpdateItemResult {
    case failure(ItemError)
    case success
}

typealias UpdateItemHandler = (UpdateItemResult) -> Void


// MARK: - File Manager

// MARK: - Core Data

// MARK: - Firebase
