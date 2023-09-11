//
//  UserCollectionStore.swift
//  Reelhub
//
//  Created by Teddy Moussignac on 4/24/23.
//

import SwiftUI

@MainActor
final class RelationshipStore: ObservableObject {
    @Published var streams = [Stream]()
    @Published var users = [User]()
    @Published var fetching = false
    @Published var store = StreamStore.shared
    
    var query: Cloud.Query = Cloud.Query()
    var relationship: User.Relationship
    var page = 1
    
    init (_ relationship: User.Relationship? = nil) {
        self.relationship = relationship ?? .LIKED
    }
    
    func fetch () {
        Task {
            withAnimation { fetching = true }
            if let streams = try? await store.getRelationship(relationship, page: page) {
                self.streams.append(contentsOf: streams)
            }
            withAnimation { fetching = false }
        }
    }
}
