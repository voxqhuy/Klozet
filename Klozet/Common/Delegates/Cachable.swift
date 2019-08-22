//
//  Cachable.swift
//  Klozet
//
//  Created by Developers on 8/22/19.
//

import Foundation

enum CacheKey {
    case item
}

// TODO: maybe make this a class MyCache with 2 properties: key, id
protocol Cachable {
    func cacheAndReturnUrl()
    
    func imageFromCache(url: URL)
}

extension Cachable {
    private func cacheKey(for key: CacheKey, withId id: String) -> String {
        switch key {
        case .item:
            return "Item.\(id)"
        }
    }
    
    func cacheAndReturnUrl(for key: CacheKey, withId id: String) {
        let url = FileManagerUtil().cachingURL(forKey: cacheKey(for: <#T##CacheKey#>, withId: <#T##String#>))
        do {
            try imageData.write(to: imageUrl)
            return imageUrl
        } catch {
            throw MyError.failToCacheImage
        }
    }
}
