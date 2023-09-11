//
//  StreamStore.swift
//  Reelhub
//
//  Created by Teddy Moussignac on 4/2/23.
//

import Foundation

final class StreamStore: ObservableObject {
    static let shared = StreamStore()
    
    @Published var genres = [Stream.Genre]()
    @Published var services = [Stream.Service]()
    
    init () {
        Task.init {
            let response: Cloud.Response = try await Cloud.request(.settings)
            DispatchQueue.main.async {
                // set genres
                if let genres = response.genres {
                    self.genres = genres.sorted { $0.name < $1.name }.filter { $0.id != 7 && $0.id != 2 }
                }
                // set services
                if let services = response.services {
                    self.services = services.sorted { $0.name < $1.name }
                }
            }
        }
    }
    
    ///
    /// Retrive endpoint from paramaters.
    ///
    /// - query:
    ///  - query: Stream.query api call query.
    private func getPath(query: Cloud.Query) -> Cloud.Endpoint {
        var path = Cloud.Endpoint.stream

        if query.keyword != nil {
            path = Cloud.Endpoint.search
        }

        if let section = query.section,
           let endpoint = Cloud.Endpoint(rawValue: section) {
            path = endpoint
        }

        return path
    }

    /// Fetches api with given query.
    ///
    /// - query:
    ///   - query: `Stream.query`
    public func fetch(query: Cloud.Query = Cloud.Query(), cacheable: Bool = true) async throws -> Cloud.Response {
        // Retrieve endpoint
        let path = getPath(query: query)
        let response: Cloud.Response = try await Cloud.request(path, claims: query)
        return response
    }
    
    ///
    public func getRelationship (_ relationship: User.Relationship, page: Int?) async throws -> [Stream]? {
        if let user = await UserStore.shared.user {
            var endpoint: Cloud.Endpoint? = nil
            var claims = Stream.Claims()
            claims.page = page ?? 1
            claims.user = Stream.User(user: user)
            
            switch relationship {
            case .LIKED:
                claims.likedList = true
                endpoint = .likedList
            case .BOOKMARKED:
                claims.bookmarkedList = true
                endpoint = .bookmarkedList
            case .WATCHED:
                claims.watchedList = true
                endpoint = .watchedList
            }
 
            let response: Cloud.Response = try await Cloud.request(endpoint!, method: .post, claims: claims)
            return response.streams
        }
        return nil
    }
}
