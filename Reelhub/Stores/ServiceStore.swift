//
//  ServiceStore.swift
//  Reelhub
//
//  Created by Teddy Moussignac on 1/30/22.
//

import SwiftUI

final class ServiceStore: CloudStore {
    var title = ""
    var titleColor: Color = .appPrimary
    var service: Stream.Service? = nil

    @Published var collectionStore: CollectionStore? = nil
    @Published var genresCollectionStore: CollectionStore? = nil
    @Published var genreLinkIsActive = false
    @Published var streamLinkIsActive = false
    @Published var collectionLinkIsActive = false

    var genreCollectionStore: CollectionStore {
        genresCollectionStore != nil ? genresCollectionStore! : CollectionStore()
    }

    var genres: [Stream.Genre] {
        StreamStore.shared.genres.sorted { $0.name < $1.name }
    }

    let topItemsCount = 4

    var topItems: [Stream] {
        return Array(items.prefix(topItemsCount))
    }

    var bottomItems: [Stream] {
        if items.count > 3 {
            return Array(items[topItemsCount...(topItemsCount*3)])
        }
        return items
    }

    override init() {
        super.init()
    }

    init (service: Stream.Service) {
        super.init()
        query = Cloud.Query(
            services: [service.name],
            limit: 24
        )

        self.service = service
        title = service.fullName
        titleColor = service.theme.primary
    }
}
