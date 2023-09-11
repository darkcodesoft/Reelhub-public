//
//  Account.swift
//  Reelhub
//
//  Created by Teddy Moussignac on 11/29/22.
//

import Foundation

struct Account: Identifiable, Encodable, Decodable, Hashable {
    var active = true
    var created = Date().timeIntervalSince1970
    var id = UUID().description
    var lastActive = Date().timeIntervalSince1970
}
