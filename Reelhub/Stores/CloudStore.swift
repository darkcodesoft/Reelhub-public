//
//  CloudStore.swift
//  Reelhub
//
//  Created by Teddy Moussignac on 1/30/22.
//

import SwiftUI

@MainActor
class CloudStore: ObservableObject {
    @Published var fetching = false
    @Published var items: [Stream] = []
    @Published var store = StreamStore.shared
    @Published var showProgressView = false
    @Published var query = Cloud.Query()
    @Published var hasMore = true
    
    var showFooterLoader: Bool {
        fetching == true && items.count != 0
    }

    var showOverlayLoader: Bool {
        fetching == true && items.count == 0 && showProgressView == true
    }

    /// Fetch with the current `Stream.query` config.
    /// Sets `items`, `genres` and `services` if requested.
    func fetch () {
        Task {
            withAnimation { fetching = true }
            // temp
            if let user = UserStore.shared.user {
                query.uid = user.uid
            }
            
            if let items = try? await StreamStore.shared.fetch(query: query).streams {
                self.items.append(contentsOf: items)
                hasMore = items.count == query.limit
            }
            
            withAnimation { fetching = false }
        }
    }

    /// Fetch next page.
    func fetchNext () {
        if hasMore {
            query.page += 1
            fetch()
        }
    }
}
