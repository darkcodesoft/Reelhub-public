//
//  FinderView.swift
//  Reelhub
//
//  Created by Teddy Moussignac on 12/12/21.
//

import SwiftUI

struct FinderView: View {
    @EnvironmentObject var store: FinderStore

    @State private var navigationLinkIsActive = false
    @State private var streamStore: StreamDetailedStore? = nil

    var body: some View {
        NavigationView {
            ZStack {
                /// Shared NavigationLink.
                NavigationLink(
                    destination: StreamView().environmentObject(streamStore ?? .init()),
                    isActive: $navigationLinkIsActive
                ) { EmptyView().frame(width: 0, height: 0) }

                /// Collection NavigationLink.
                NavigationLink(
                    destination: CollectionView().environmentObject(store.collection),
                    isActive: $store.collectionIsActive
                ) { EmptyView().frame(width: 0, height: 0) }

                if store.keyword.isEmpty &&
                    store.items.isEmpty &&
                    store.keywordItems.isEmpty &&
                    !store.fetching {
                    ScrollView {
                        // Genres list.
                        GenreButtons(items: StreamStore.shared.genres)
                            .padding(.horizontal)
                            .padding(.bottom)
                    }
                } else {
                    /// Results
                    /// Directors, Creators & Cast
                    if !store.keyword.isEmpty {
                        List {
                            // persons results
                            if store.persons != nil && !store.persons!.isEmpty && !store.fetching {
                                Section(header: Text(String.persons).foregroundColor(.appSecondary).font(.small).fontWeight(.bold)) {
                                    ForEach(store.persons!) { person in
                                        Button(action: {
                                            navigateTo(person: person)
                                        }, label: {
                                            HStack {
                                                Text(person.name)
                                                Spacer()
                                                Image(systemName: "chevron.right")
                                                    .foregroundColor(.gray)
                                            }
                                        })
                                        .listRowSeparator(.hidden)
                                    }
                                }
                            }
                            
                            // Keyword results.
                            if !store.keywordItems.isEmpty && !store.fetching {
                                Section(header: Text("\(.movies) & \(.series)").foregroundColor(.appSecondary).font(.small).fontWeight(.bold)) {
                                    ForEach(store.keywordItems) { stream in
                                        Button(action: {
                                            navigateTo(stream: stream)
                                        }, label: {
                                            StreamRowView(stream: stream)
                                                .onAppear {
                                                    if stream == store.items.last && !store.fetching {
                                                        store.fetchNext()
                                                    }
                                                }
                                        })
                                    }
                                }
                            }
                        }
                        .listStyle(.plain)
                    } else {
                        // Finder Filter results.
                        if !store.items.isEmpty && store.keyword.isEmpty {
                            // Grid
                            StreamVGridView(items: store.items, fetching: false) {
                                if !store.fetching {
                                    store.fetchNext()
                                }
                            }
                        }
                    }
                }

                // Overlay Loader...
                if store.fetching && store.items.count == 0 {
                    HStack {
                        Spacer()
                        ProgressView()
                        Spacer()
                    }
                }
            }
            .searchable(text: $store.keyword, placement: .navigationBarDrawer(displayMode: .always), prompt: String.keyword)
            .navigationTitle(store.title)
            .colorScheme(.dark)
            .sheet(isPresented: $store.editPreferences) {
                StreamPreferencesView()
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        store.editPreferences.toggle()
                    }, label: {
                        HStack {
                            Text(String.filter)
                            Image(systemName: "slider.horizontal.3")
                        }
                        .foregroundColor(.appSecondary)
                     })
                }
            }
        }
    }

    /// Set current `StreamDetailedStore`.
    ///
    /// - Parameters:
    ///   - stream: stream item
    func navigateTo (stream: Stream? = nil, person: Stream.Person? = nil) {
        if let stream = stream {
            streamStore = StreamDetailedStore(stream: stream)
            navigationLinkIsActive = true
        }
        else if let person = person {
            store.collection = CollectionStore(person: person)
            store.collectionIsActive = true
        }
    }
}

struct FinderView_Previews: PreviewProvider {
    static var previews: some View {
        let store = FinderStore()
        FinderView()
            .environmentObject(store)
            .environment(\.colorScheme, .dark)
    }
}
