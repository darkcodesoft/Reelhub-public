//
//  BrowseStore.swift
//  Reelhub
//
//  Created by Teddy Moussignac on 1/13/22.
//

import SwiftUI

final class BrowseStore: CloudStore {
    /// Shared singleton variable.
    static let shared = BrowseStore()
    static let limit = 10

    @Published var serviceStore: ServiceStore? = nil
    @Published var streamLinkIsActive = false
    @Published var serviceLinkIsActive = false
    @Published var sections = [[Stream]]()

    var genres: [Stream.Genre] {
        StreamStore.shared.genres.sorted { $0.name < $1.name }
    }

    var services: [Stream.Service] {
        StreamStore.shared.services.sorted { $0.name < $1.name }
    }
    
    private func setSection (streams: [Stream]) -> [[Stream]] {
       let group = Dictionary(
            grouping: streams,
            by: { $0.section }
        )

        let sorted = group.values.sorted { $0.first!.section! < $1.first!.section! }
        return sorted
    }
    
    /// Creates a variable of self with array of `Stream` items.
    ///
    /// - query:
    ///   - items: Array of `Stream` items.
    override init () {
        super.init()
        query = Cloud.Query(
            section: Cloud.Endpoint.browse.rawValue,
            limit: Self.limit
        )
    }
    
    override func fetch () {
        Task {
            withAnimation { fetching = true }
            if let items = try? await StreamStore.shared.fetch(query: query).streams {
                sections = setSection(streams: items)
            }
            withAnimation { fetching = false }
        }
    }
}
