//
//  MenuItem.swift
//  Reelhub
//
//  Created by Teddy Moussignac on 3/19/23.
//

import SwiftUI

extension MoreMenuView {
    
    enum ViewName: String, Codable {
        case Account
        case Help
    }
    
    struct Menu {
        var sections = [Section]()
        
        struct Section: Codable, Equatable, Identifiable {
            var id = UUID()
            var name: String? = nil
            var items: [Item] = [Item]()
        }
        
        struct Item: Codable, Equatable, Identifiable {
            var id = UUID()
            var label: String? = nil
            var icon: String? = nil
            var url: String? = nil
            var relationship: User.Relationship? = nil
            var destinationViewName: MoreMenuView.ViewName? = nil
        }
    }
}
