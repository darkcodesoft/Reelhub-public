//
//  GenreButtons.swift
//  Reelhub
//
//  Created by Teddy Moussignac on 1/14/22.
//

import SwiftUI

struct GenreButtons: View {
    var items: [Stream.Genre]
    var service: Stream.Service? = nil

    @State private var store: CollectionStore? = nil
    @State private var navigationLinkIsActive = false

    var body: some View {
        ZStack {
            /// Genre Collection NavigationLink.
            NavigationLink(
                destination: CollectionView().environmentObject(store ?? .init()),
                isActive: $navigationLinkIsActive
            ) { EmptyView().frame(width: 0, height: 0) }

            /// Grid.
            LazyVGrid(columns: Array(repeating: .init(.flexible(), spacing: .small), count: 2)) {
                ForEach(items, id: \.self) { genre in
                    Button(action: {
                        navigateTo(genre: genre)
                    }, label: {
                        HStack {
                            Spacer()
                            Text(genre.tag)
                                .font(.small)
                                .foregroundColor(.appPrimary)
                                .padding(.vertical)
                            Spacer()
                        }
                        .background(Color.appGray)
                        .cornerRadius(.radiusMedium)
                    })
                }
            }
        }
    }


    /// Set current `StreamDetailedStore`.
    ///
    /// - Parameters:
    ///   - stream: stream item
    func navigateTo (genre: Stream.Genre) {
        Task.init {
            store = await CollectionStore(genres: [genre], service: service)
            navigationLinkIsActive = true
        }
    }
}

struct GenreButtons_Previews: PreviewProvider {
    static var previews: some View {
        let streams = [Stream]()
        let stream = streams.randomElement()!
        GenreButtons(items: stream.genres!)
            .colorScheme(.dark)
    }
}
