//
//  ImageCache.swift
//  Reelhub
//
//  Created by Teddy Moussignac on 2/20/22.
//

import Foundation
import SwiftUI

/// ImageCache class usin NSCache.
/// Note: Cache items can be cleared
/// by the system at anytime to make space.
class ImageCache {
    /// Cache prefix key
    static let prefix = "reelhub_image_"

    /// NSCache instance.
    var cache = NSCache<NSString, ImageCache.Item>()

    /// Get cache item if any. Cache items can be cleared
    /// by the system at anytime to make space.
    ///
    /// - Parameters:
    ///  - forKey: String cache key.
    func get(forKey: String) -> ImageCache.Item? {
        let key = Self.prefix + forKey
        return cache.object(forKey: NSString(string: key))
    }

    /// Set Cache Item.
    ///
    /// - Parameters:
    ///  - forKey: String cache key.
    ///  - item: Item cache key.
    func set(forKey: String, item: ImageCache.Item) {
        let key = Self.prefix + forKey
        cache.setObject(item, forKey: NSString(string: key))
    }
}

extension ImageCache {
    /// Shared image cache instance.
    static var shared = ImageCache()

    /// Image Cache item
    class Item {
        /// Image object to cache
        var image: Image

        /// Intializer
        ///
        /// - Parameters:
        ///  - image: Image to cache.
        init (image: Image) {
            self.image = image
        }
    }
}
