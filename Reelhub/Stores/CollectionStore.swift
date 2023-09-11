//
//  CollectionStore.swift
//  Reelhub
//
//  Created by Teddy Moussignac on 1/25/22.
//

import SwiftUI

final class CollectionStore: CloudStore {
    var title = String.search
    var subTitle: String? = nil
    var stream: Stream? = nil
    var titleColor: Color = .appPrimary

    /// Creates a variable of self.
    /// Initialize
    ///
    override init() {
        super.init()
     }
    
    /// Creates a variable of self with array of `Genre` items.
    ///
    /// - query:
    ///  - genres: Array of `Genre`s.
    init (genres: [Stream.Genre], service: Stream.Service? = nil) {
        super.init()
        if let service = service {
            title = service.fullName
            subTitle = genres.first?.tag ?? ""
            titleColor = service.theme.primary
            query.genres = genres.map { $0.id }
            query.services = [service.name]
        } else {
            title = genres.first?.tag ?? ""
            query.genres = genres.map { $0.id }
        }
    }

    /// Creates a variable of self for `Person`.``
    ///
    /// - query:
    ///  - person: `Person`.
    init (person: Stream.Person) {
        super.init()
        title = person.name
        query.person = person.name
    }


    /// Creates a variable of self with array of `Service` items.
    ///
    /// - query:
    ///  - services: Array of `Service`s.
    init (services: [Stream.Service]) {
        super.init()
        if let first = services.first {
            title = first.fullName
            titleColor = first.theme.primary
        }
        query.services = services.map { $0.name }
    }

    /// Creates a variable of self for `Type`.``
    ///
    /// - query:
    ///  - type: `Stream.Type` name.
    init (type: String) {
        super.init()
        let type = Stream.Types(rawValue: type)
        title = type == .movie ? .movies : .series
        query.type = type!.rawValue
    }
 }
