//
//  UserCollectionView.swift
//  Reelhub
//
//  Created by Teddy Moussignac on 3/23/23.
//

import SwiftUI

// View
struct RelationshipView: View {
    @EnvironmentObject var store: RelationshipStore
    
    @State private var navigationLinkIsActive = false
    @State private var streamDetailedStore: StreamDetailedStore? = nil
    
    var body: some View {
        ZStack {
            /// Shared NavigationLink.
            NavigationLink(
                destination: StreamView().environmentObject(streamDetailedStore ?? .init()),
                isActive: $navigationLinkIsActive
            ) { EmptyView().frame(width: 0, height: 0) }
            
            List {
                if store.streams.count > 0 {
                    // Stream collection
                    ForEach(store.streams) { stream in
                        Button(action: {
                            navigateTo(stream: stream)
                        }, label: {
                            StreamRowView(stream: stream)
                                .onAppear {
                                    if !store.streams.isEmpty && stream == store.streams.last && !store.fetching {
                                        if store.streams.count >= store.query.limit {
                                            store.page += 1
                                            store.fetch()
                                        }
                                    }
                                }
                        })
                    }
                    .onDelete(perform: delete)
                }
            }
            .listStyle(.plain)
            .navigationTitle(store.relationship.rawValue.capitalized)
            .toolbar {
                EditButton()
            }
            .onAppear {
                if store.streams.isEmpty {
                    store.fetch()
                }
            }
            
            // Overlay Loader...
            if store.fetching == true && store.streams.count == 0 {
                HStack {
                    Spacer()
                    ProgressView()
                    Spacer()
                }
            }
        }
    }
    
    /// Set current `StreamDetailedStore`.
    ///
    /// - Parameters:
    ///   - stream: stream item
    func navigateTo (stream: Stream) {
        streamDetailedStore = StreamDetailedStore(stream: stream)
        navigationLinkIsActive = true
    }
    
    ///
    func delete(at offsets: IndexSet) {
        if store.streams.count > 0, let index = offsets.first {
            var stream = store.streams[index]
            switch store.relationship {
            case .LIKED:
                stream.liked = false
            case .BOOKMARKED:
                stream.bookmarked = false
            case .WATCHED:
                stream.watched = false
            }
        }
     }
}

 struct RelationshipView_Previews: PreviewProvider {
     static var previews: some View {
         RelationshipView()
     }
 }
