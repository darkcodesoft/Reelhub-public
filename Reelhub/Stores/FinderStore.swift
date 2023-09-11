//
//  FinderStore.swift
//  Reelhub
//
//  Created by Teddy Moussignac on 12/22/21.
//

import SwiftUI

final class FinderStore: CloudStore {
    /// Shared singleton variable.
    static var shared = FinderStore()

    // @Published var title = String.finder
    @Published var editPreferences: Bool = false
    @Published var age: [Int] = []
    @Published var stream: Stream? = nil
    @Published var collection: CollectionStore = .init()
    @Published var collectionIsActive = false
    @Published var persons: [Stream.Person]? = nil
    @Published var keywordItems: [Stream] = []

    let personsCount = 4

    @Published var keyword: String = "" {
        didSet {
            if keyword.count > 2 {
                fetch()
            } else {
                persons = nil
                items = []
            }
        }
    }

    /// Selected stream `Type` `Movie vs Series`.
    @Published var type: Stream.Types = .both {
        didSet {
            if type != .both {
                query.type = type.id
            } else {
                query.type = nil
            }
            preferencesChanged = true
        }
    }
    
    /// Selected stream `Type` `Movie vs Series`.
    @Published var order: Stream.OrderBy = .year {
        didSet {
            query.order = order.rawValue
            preferencesChanged = true
        }
    }
    
    @Published var genrePreferenceChanged = false {
        didSet {
            if genrePreferenceChanged == true {
                preferencesChanged = true
            }
        }
    }

    @Published var servicePreferenceChanged = false {
        didSet {
            if servicePreferenceChanged == true {
                preferencesChanged = true
            }
        }
    }
    
    @Published var preferencesChanged = false {
        didSet {
            if preferencesChanged == true {
                keyword = ""
                query.keyword = nil
                query.page = 1
                persons = nil
                items = []
            }
        }
    }
    
    var genres: [Stream.Genre] { StreamStore.shared.genres }

    var services: [Stream.Service] { StreamStore.shared.services }

    /// Filter selected genres and return the first 5 genre name strings
    var selectedGenres: String {
        let items = StreamStore.shared.genres.filter{ $0.isOn }.map { $0.name }
        // return blank is no or all selection
        if items.count == StreamStore.shared.genres.count {
            return ""
        }
        // if 2
        if items.count == 2 {
            return Array(items).joined(separator: " & ") + " "
        }
        // return first 4 items
        let size = items.count < 5 ? items.count : 4
        return Array(items[0...size-1]).joined(separator: ", ") + " "
    }

    /// Filter selected services and return the first 5 service fullName strings
    var selectedServices: String {
        let items = StreamStore.shared.services.filter{ $0.isOn }.map { $0.fullName }
        // return blank is no or all selection
        if items.count == StreamStore.shared.services.count {
            return ""
        }
        // if 2
        if items.count == 2 {
            return Array(items).joined(separator: " & ") + " "
        }
        // return first 4 items
        let size = items.count < 5 ? items.count : 4
        return Array(items[0...size-1]).joined(separator: ", ") + " "
    }
    
    // Get Title based on user selection
    var title: String {
        if !items.isEmpty && keyword.isEmpty {
            return selectedServices +  selectedGenres + type.name
        }
        return String.finder
    }
    
    /// Toggle all `Genre` options.
    @Published var allGenres: Bool = true {
        didSet {
            setGenres(isOn: allGenres)
            if keyword.isEmpty {
                genrePreferenceChanged = true
                preferencesChanged = true
            }
        }
    }

    /// Toggle all `Service` options.
    @Published var allServices: Bool = true {
        didSet {
            setServices(isOn: allServices)
            if keyword.isEmpty {
                servicePreferenceChanged = true
                preferencesChanged = true
            }
        }
    }
     
    ///
    private func setGenereParameter () {
        query.genres = StreamStore.shared.genres.filter { $0.isOn }.map { $0.id }
    }

    ///
    private func setServiceParameter () {
        query.services = StreamStore.shared.services.filter { $0.isOn }.map { $0.name }
    }

    ///
    private func setGenres (isOn: Bool = true) {
        let genres: [Stream.Genre] = StreamStore.shared.genres.map {
            var genre = $0
            genre.isOn = isOn
            return genre
        }
        StreamStore.shared.genres = genres
    }

    ///
    private func setServices (isOn: Bool = true) {
        let services: [Stream.Service] = StreamStore.shared.services.map {
            var service = $0
            service.isOn = isOn
            return service
        }
        StreamStore.shared.services = services
    }

    /// Fetch with the current `Stream.query` config.
    /// Sets `items`, `genres` and `services` if requested.
    override func fetch () {
        Task {
            // Set genre paramter
            if genrePreferenceChanged {
                setGenereParameter()
            }

            // set service parameter
            if servicePreferenceChanged {
                setServiceParameter()
            }

            // set keyword parameter
            if !keyword.isEmpty && keyword.count > 2 {
                query = .init(keyword: keyword)
                // reset genres and services selection
                // For more broader search
                allGenres = true
                allServices = true
            }

            withAnimation { fetching = true }
            if let response = try? await StreamStore.shared.fetch(query: query) {
                // if items
                if let items = response.streams {
                    if preferencesChanged {
                        if keyword.isEmpty {
                            self.items = items
                            self.keywordItems = []
                        } else {
                            self.items = []
                            self.keywordItems = items
                        }
                    } else {
                        if keyword.isEmpty {
                            self.items.append(contentsOf: items)
                            self.keywordItems = []
                        } else {
                            self.items = []
                            self.keywordItems = items
                        }
                    }
                }
                // if persons
                if let persons = response.persons {
                    if persons.count >= personsCount {
                        self.persons = Array(persons[0...personsCount-1])
                    } else {
                        self.persons = persons
                    }
                }

                preferencesChanged = false
                genrePreferenceChanged = false
                servicePreferenceChanged = false
            }
            withAnimation { fetching = false }
        }
    }
}
