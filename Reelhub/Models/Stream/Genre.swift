//
//  Genre.swift
//  Reelhub
//
//  Created by Teddy Moussignac on 12/21/21.
//

import Foundation

extension Stream {
    struct Genre: Identifiable, Codable, Hashable {
        var id: Int
        var name: String
        var isOn = true
        
        var tag: String {
            return "#\(name.convertedToSlug() ?? "")"
        }
    }
}
