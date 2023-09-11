//
//  CollectionView.swift
//  Reelhub
//
//  Created by Teddy Moussignac on 1/18/22.
//

import SwiftUI

struct CollectionView: View {
    @EnvironmentObject var store: CollectionStore

    var body: some View {
        ZStack {
            StreamVGridView(items: store.items, fetching: store.showFooterLoader) {
                if !store.fetching {
                    store.fetchNext()
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    HStack {
                        Text(store.title)
                            .font(.title3)
                            .fontWeight(.black)
                            .foregroundColor(store.titleColor)
                        if let subTitle = store.subTitle {
                            Text(subTitle)
                                .font(.title3)
                                .fontWeight(.black)
                                .foregroundColor(.appPrimary)
                        }
                    }
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

            // Overlay Loader...
            if store.showOverlayLoader {
                HStack {
                    Spacer()
                    ProgressView()
                    Spacer()
                }
            }
        }
    }
}

struct StreamResultView_Previews: PreviewProvider {
    static var previews: some View {
        let store = CollectionStore()
        CollectionView()
            .environmentObject(store)
            .colorScheme(.dark)
    }
}
