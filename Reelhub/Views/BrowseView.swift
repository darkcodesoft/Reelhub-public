//
//  BrowseView.swift
//  Reelhub
//
//  Created by Teddy Moussignac on 1/12/22.
//

import SwiftUI

struct BrowseView: View {
    @EnvironmentObject var store: BrowseStore

    var body: some View {
        NavigationView {
            ZStack {
                /// Service Collection NavigationLink.
                NavigationLink(
                    destination: ServiceView().environmentObject(store.serviceStore ?? .init()),
                    isActive: $store.serviceLinkIsActive
                ) { EmptyView().frame(width: 0, height: 0) }

                ScrollView (showsIndicators: false) {
                    VStack(alignment: .leading) {
                        // If sections loaded
                        if store.sections.count > 0 {
                            ForEach(store.sections, id: \.self) { section in
                                if let service = StreamStore.shared.services.filter({ $0.name == section.first!.section }).first {
                                    // title
                                    HStack {
                                        SectionHeader(title: service.fullName)
                                            .foregroundColor(service.theme.primary)
                                        Spacer()
                                        Text(String.seeAll)
                                            .font(.body)
                                            .foregroundColor(.appSecondary)
                                    }
                                    .padding(.horizontal)
                                    .onTapGesture {
                                        store.serviceStore = ServiceStore(service: service)
                                        store.serviceLinkIsActive = true
                                    }
                                    // Section lists
                                    StreamCarouselView(items: section)
                                }
                            }
                            // Genres
                            if !store.genres.isEmpty {
                                VStack(alignment: .leading) {
                                    // Title
                                    HStack {
                                        SectionHeader(title: String.all)
                                            .foregroundColor(.appSecondary)
                                        Text(String.genres)
                                            .font(.body)
                                            .foregroundColor(.appPrimary)
                                    }
                                    // Grid
                                    GenreButtons(items: store.genres)
                                }
                                .padding()
                            }
                        }
                    }
                }

                // Overlay Loader...
                if store.sections.isEmpty && store.fetching {
                    HStack {
                        Spacer()
                        ProgressView()
                        Spacer()
                    }
                }
            }
            .navigationTitle(String.browse)
            .task {
                if store.sections.isEmpty  {
                    store.fetch()
                }

                DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                    withAnimation {
                        store.showProgressView = true
                    }
                }
            }
        }
    }
}

struct BrowseView_Previews: PreviewProvider {
    static var previews: some View {
        let store = BrowseStore()
        BrowseView()
            .environmentObject(store)
            .colorScheme(.dark)
    }
}
