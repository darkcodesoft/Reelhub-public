//
//  ServiceView.swift
//  Reelhub
//
//  Created by Teddy Moussignac on 1/30/22.
//

import SwiftUI

struct ServiceView: View {
    @EnvironmentObject var store: ServiceStore

    var body: some View {
        ZStack {
            /// Collection NavigationLink.
            NavigationLink(
                destination: CollectionView().environmentObject(store.collectionStore ?? CollectionStore()),
                isActive: $store.collectionLinkIsActive
            ) { EmptyView().frame(width: 0, height: 0) }

            ScrollView(showsIndicators: false) {
                if store.items.count > 0 {
                    // Top items
                    StreamVGridView(items: store.topItems, fetching: false)

                    // Latests carousel
                    VStack(alignment: .leading) {
                        // Section header Group.
                        HStack {
                            SectionHeader(title: store.service!.fullName)
                                .foregroundColor(store.service!.theme.primary)
                            Text(String.latest)
                                .foregroundColor(.appPrimary)
                            Spacer()
                            Text(String.seeAll)
                                .font(.body)
                                .foregroundColor(store.service!.theme.primary)
                        }
                        .padding(.horizontal)
                        .onTapGesture {
                            store.collectionStore = .init(services: [store.service!])
                            store.collectionLinkIsActive = true
                        }

                        // Caoursel
                        StreamCarouselView(items: store.bottomItems)
                    }

                    // Genres List
                    VStack(alignment: .leading) {
                        // Title
                        HStack {
                            SectionHeader(title: store.service!.fullName)
                                .foregroundColor(store.service!.theme.primary)
                            Text(String.genres)
                                .foregroundColor(.appPrimary)
                        }
                        // Grid
                        GenreButtons(items: store.genres, service: store.service)
                    }
                    .padding()
                }
            }

            // Overlay Loader...
            if store.showOverlayLoader {
                HStack {
                    Spacer()
                    ProgressView()
                    Spacer()
                }
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text(store.title)
                    .font(.title3)
                    .fontWeight(.black)
                    .foregroundColor(store.service?.theme.primary)
            }
        }
        .onAppear {
            if store.items.isEmpty && !store.fetching {
                store.fetch()
            }
        }
        .task {
            store.showProgressView = true
        }
    }
}

struct ServiceView_Previews: PreviewProvider {
    static var previews: some View {
        let service = Stream.Service(id: 1, name: "apple", isOn: true)
        let store = ServiceStore(service: service)
        ServiceView()
            .environmentObject(store)
    }
}
