//
//  HomeView.swift
//  Reelhub
//
//  Created by Teddy Moussignac on 1/12/22.
//

import SwiftUI

struct HomeView: View {
    @EnvironmentObject var store: HomeStore
    @EnvironmentObject var userStore: UserStore
    
    var body: some View {
        NavigationView {
            GeometryReader { geometry in
                ZStack {
                    // Overlay Loader...
                    if store.items.isEmpty && store.fetching {
                        VStack {
                            Spacer()
                            HStack {
                                Spacer()
                                ProgressView()
                                Spacer()
                            }
                            Spacer()
                        }
                    } else {
                        TabView {
                            if store.items.count > 0 {
                                ForEach(store.items) { stream in
                                    StreamCardView()
                                        .environmentObject(StreamCardStore(stream: stream))
                                        .rotationEffect(.degrees(-90)) // Rotate content
                                        .frame(
                                            width: geometry.size.width,
                                            height: geometry.size.height
                                        )
                                        .onAppear {
                                            if !store.items.isEmpty && stream == store.items.last && !store.fetching {
                                                store.fetchNext()
                                            }
                                        }
                                }
                            }
                        }
                        .frame(
                            width: geometry.size.height, // Height & width swap
                            height: geometry.size.width
                        )
                        .rotationEffect(.degrees(90), anchor: .topLeading) // Rotate TabView
                        .offset(x: geometry.size.width) // Offset back into screens bounds
                        .tabViewStyle(
                            PageTabViewStyle(indexDisplayMode: .never)
                        )
                    }
                }
            }
            .navigationBarHidden(true)
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        let store = HomeStore()
        HomeView()
            .environmentObject(store)
            .colorScheme(.dark)
    }
}
