//
//  Service.swift
//  Reelhub
//
//  Created by Teddy Moussignac on 12/21/21.
//

import Foundation
import SwiftUI

extension Stream {
    struct Service: Identifiable, Codable, Hashable {
        var id: Int
        var name: String
        var added: String?
        var leaving: String?
        var link: String?
        var isOn = true
        
        /// Gets service provider full name
        var fullName: String {
            set { name = newValue }
            get { Provider.name(name) }
        }

        /// Get service provider theme color
        var theme: Color.Theme {
            return Color.service(name)
        }
    }
}
