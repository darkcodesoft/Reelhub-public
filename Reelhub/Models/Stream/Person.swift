//
//  Person.swift
//  Reelhub
//
//  Created by Teddy Moussignac on 12/21/21.
//

import Foundation

extension Stream {
    struct Person: Identifiable, Codable, Hashable {
        var id: Int
        var name: String
    }
}
