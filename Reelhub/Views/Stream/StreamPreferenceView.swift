//
//  StreamPreferencesView.swift
//  Reelhub
//
//  Created by Teddy Moussignac on 12/27/21.
//

import SwiftUI

struct StreamPreferencesView: View {
    @EnvironmentObject var store: StreamStore
    @EnvironmentObject var finderStore: FinderStore

    var body: some View {
        NavigationView {
            List {
                // Types
                Section(footer: Text(String.typeCaption)) {
                    Picker(String.format, selection: $finderStore.type) {
                        ForEach(Stream.Types.allCases, id:\.self) { type in
                            HStack {
                                switch type {
                                case .movie:
                                    Text(String.movie)
                                case .series:
                                    Text(String.series)
                                default:
                                    Text("\(String.movie) & \(String.series)")
                                        .padding(.trailing)
                                }
                            }
                        }
                    }
                }
                
                // Order By
                Section(footer: Text(String.orderCaption)) {
                    Picker(String.sort, selection: $finderStore.order) {
                        ForEach(Stream.OrderBy.allCases, id:\.self) { order in
                            HStack {
                                switch order {
                                case .imdbVoteCount:
                                    Text(String.mostPopular)
                                case .imdbRating:
                                    Text(String.highestRated)
                                default:
                                    Text(String.mostRecent)
                                }
                            }
                        }
                    }
                }
                
                // Services options
                Section(header: HStack {
                    Toggle(String.services, isOn: $finderStore.allServices)
                        .tint(.green)
                }) {
                    ForEach($store.services, id: \.self) { service in
                        Toggle(service.fullName.wrappedValue, isOn: service.isOn)
                            .tint(.green)
                            .onTapGesture {
                                finderStore.servicePreferenceChanged = true
                            }
                    }
                }
                
                // Genres options
                Section(header: HStack {
                    Toggle(String.genres, isOn: $finderStore.allGenres)
                        .tint(.green)
                }) {
                    ForEach($store.genres, id: \.self) { genre in
                        Toggle(genre.name.wrappedValue, isOn: genre.isOn)
                            .tint(.green)
                            .onTapGesture {
                                finderStore.genrePreferenceChanged = true
                            }
                    }
                }
            }
            .listStyle(.insetGrouped)
            .navigationTitle(String.filter)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                Button(action: {
                    finderStore.editPreferences.toggle()
                }, label: {
                    Text(String.done)
                })
            }
        }
        .colorScheme(.dark)
        .onDisappear {
            if finderStore.preferencesChanged && !finderStore.fetching {
                finderStore.fetch()
            }
        }
    }
}

struct StreamPreferencesView_Previews: PreviewProvider {
    static var previews: some View {
        StreamPreferencesView()
    }
}
