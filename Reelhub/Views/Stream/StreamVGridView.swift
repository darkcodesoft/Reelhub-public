//
//  StreamVGridView.swift
//  Reelhub
//
//  Created by Teddy Moussignac on 12/22/21.
//

import SwiftUI

struct StreamVGridView: View {
    @Environment(\.screenSize) var screenSize

    var items: [Stream]
    /// Should allow fetching.
    var fetching: Bool = false
    /// Last item `onAppear` completion closure.
    var completion: (() -> Void)? = nil

    @State private var store: StreamDetailedStore? = nil
    @State private var navigationLinkIsActive = false

    /// Base on 27×40-inch posters
    /// Movie posters are width is 67.5% of its height
    var gridWidth: CGFloat {
        screenSize.width / 2 - .medium
    }

    var gridHeight: CGFloat {
        (gridWidth / 0.675) + (.fontSizeizeSmall * 5) // 35% screen height + text padding
    }

    var body: some View {
        ScrollView (.vertical, showsIndicators: false) {
            /// Shared NavigationLink.
            NavigationLink(
                destination: StreamView().environmentObject(store ?? .init()),
                isActive: $navigationLinkIsActive
            ) { EmptyView().frame(width: 0, height: 0) }

            LazyVGrid(columns: Array(repeating: .init(.fixed(gridWidth), spacing: .small), count: 2)) {
                ForEach(items) { stream in
                    StreamCellView(stream: stream)
                        .onTapGesture {
                            navigateTo(stream: stream)
                        }
                        .onAppear {
                            if stream == items.last, let completion = completion {
                                completion()
                            }
                        }
                        .frame(width: gridWidth, height: gridHeight)
                        .clipped()
                        .tint(.clear)
                }
            }

            // Footer Loader...
            BottomProgressView(count: items.count, fetching: fetching)
        }
    }

    /// Set current `StreamDetailedStore`.
    ///
    /// - Parameters:
    ///   - stream: stream item
    func navigateTo (stream: Stream) {
        Task.init {
            store = await StreamDetailedStore(stream: stream)
            navigationLinkIsActive = true
        }
    }
}

struct StreamVGridView_Previews: PreviewProvider {
    static var previews: some View {
        let streams = [Stream]()
        StreamVGridView(items: streams)
            .environment(\.colorScheme, .dark)
    }
}
