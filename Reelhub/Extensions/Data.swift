//
//  Data.swift
//  Reelhub
//
//  Created by Teddy Moussignac on 2/25/23.
//

import Foundation

extension Data {
    ///
    ///
    ///
    func urlSafeBase64EncodedString() -> String {
        return base64EncodedString()
            .replacingOccurrences(of: "+", with: "-")
            .replacingOccurrences(of: "/", with: "_")
            .replacingOccurrences(of: "=", with: "")
    }
}
