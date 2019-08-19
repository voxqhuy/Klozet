//
//  FileManagerUtil.swift
//  Klozet
//
//  Created by Huy Vo on 8/18/19.
//

import Foundation


struct FileManagerUtil {
    // Only documents and other data that is user-generated,
    // or that cannot be recreated by your application, should be stored in
    // <Application_Home>/Documents and automatically backed up by iCloud
    func documentURL(forKey key: String) -> URL {
        let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        return documentDirectory.appendingPathComponent(key)
    }
    
    // Data that can be downloaded again should be stored in the
    // <Application_Home>/Library/Caches directory
    func cachingURL(forKey key: String) -> URL {
        let cacheDirectory = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first!
        return cacheDirectory.appendingPathComponent(key)
    }
}
