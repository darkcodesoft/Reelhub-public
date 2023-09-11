//
//  StreamDetailedStore.swift
//  Reelhub
//
//  Created by Teddy Moussignac on 1/15/22.
//

import SwiftUI

final class StreamDetailedStore: CloudStore {
    @Published var expandOverview = false
    @Published var stream: Stream? = nil
    @Published var collection: CollectionStore = .init()
    @Published var showContent: Bool = false
    
    var referred = false
    var id: Int = 0
    var title = ""
    var type = ""
    var poster = ""
    var overview: String = ""
    var genres = [Stream.Genre]()
    var services = [Stream.Service]()
    var persons = [Stream.Person]()
    var year = 0
    
    /// Get trailer ur..
    var trailerUrl: String? {
        if let video = stream?.video {
            return "https://www.youtube.com/embed/\(video)"
        }
        return nil
    }
    
    /// Creates a variable of self.
    override init() {
        super.init()
    }

    /// Creates a variable of self with `Stream` item.
    /// For by preview.
    ///
    /// - query:
    ///   - stream: `Stream` item.
    init (stream: Stream, referred: Bool = false) {
        super.init()
        query = .init(id: stream.id)

        // set default store props
        self.stream = stream
        self.referred = referred
        id = stream.id
        title = stream.title
        type = stream.type ?? ""
        poster = !stream.posterHD.isEmpty ? stream.posterHD : stream.poster
        year = stream.year ?? 0
        // fetch detailed stream
        fetch()
    }

    /// Fetch detailed stream
    override func fetch () {
        Task {
            withAnimation {
                fetching = true
            }
            query.uid = UserStore.shared.user?.uid
            let response: Cloud.Response = try await Cloud.request(.stream, claims: query)
            if let stream = response.stream {
                self.stream = stream
                type = stream.type ?? ""
                overview = stream.overview ?? ""
                genres = stream.genres ?? []
                services = stream.services ?? []
                persons = stream.persons ?? []
                year = stream.year ?? 0
            }
            withAnimation {
                fetching = false
                showContent = true
            }
        }
    }
}
