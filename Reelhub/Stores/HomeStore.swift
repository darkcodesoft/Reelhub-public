//
//  HomeStore.swift
//  Reelhub
//
//  Created by Teddy Moussignac on 1/12/22.
//

import SwiftUI

final class HomeStore: CloudStore {
    /// Shared singleton variable.
    static let shared = HomeStore()
    static let limit = 10
    
    /// Creates a variable of self with a collection of `Stream`s.
    ///
    /// - query:
    ///   - items: array of `Stream`s.
    override init () {
        super.init()
        query = Cloud.Query(
            order: Stream.OrderBy.year.rawValue,
            limit: HomeStore.limit
        )
        fetch()
    }
    
    // Refresh recommedations
    // base on user logged in states
    func refresh () {
        if !items.isEmpty {
            items.removeAll()
            fetch()
        }
    }
    
    // Fetch recommendations
    override func fetch() {
        Task {
            withAnimation { fetching = true }
            // temp
            if let user = UserStore.shared.user {
                query.uid = user.uid
            }
            
            let response: Cloud.Response = try await Cloud.request(.recommended, claims: query)
            if let streams = response.streams {
                self.items.append(contentsOf: streams)
            }
            withAnimation { fetching = false }
        }
    }
 }
