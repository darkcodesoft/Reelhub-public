//
//  StreamCache.swift
//  Reelhub
//
//  Created by Teddy Moussignac on 2/21/22.
//

import Foundation

/// StreamCache class usin NSCache.
/// Note: Cache items can be cleared
/// by the system at anytime to make space.
class StreamCache {
    /// Cache prefix key
    static let prefix = "reelhub_image_"
    
    /// NSCache instance.
    var cache = NSCache<NSString, StreamCache.Item>()

    /// Get cache item if any. Cache items can be cleared
    /// by the system at anytime to make space.
    ///
    /// - Parameters:
    ///  - forKey: String cache key.
    func get(forKey: String) -> StreamCache.Item? {
        let key = Self.prefix + forKey
        return cache.object(forKey: NSString(string: key))
    }

    /// Set Cache Item.
    ///
    /// - Parameters:
    ///  - forKey: String cache key.
    ///  - item: Stream.Response response to cache.
    func set(forKey: String, response: Cloud.Response) {
        let item = StreamCache.Item(response: response)
        let key = Self.prefix + forKey
        cache.setObject(item, forKey: NSString(string: key))
    }
}

extension StreamCache {
    /// Shared stream cache instance.
    static var shared = StreamCache()

    /// Stream Cache item
    class Item {
        /// Stream response object to cache
        var response: Cloud.Response

        /// Intializer
        ///
        /// - Parameters:
        ///  - response: Stream.Response to cache.
        init (response: Cloud.Response) {
            self.response = response
        }
    }
}
