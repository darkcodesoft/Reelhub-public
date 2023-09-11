//
//  Encodable.swift
//  Reelhub
//
//  Created by Teddy Moussignac on 4/7/23.
//

import Foundation

extension Encodable {
    subscript(key: String) -> Any? {
        return dictionary[key]
    }
    
    var dictionary: [String: Any] {
        let encoder = JSONEncoder()
        return (try? JSONSerialization.jsonObject(with: encoder.encode(self))) as? [String: Any] ?? [:]
    }
}
