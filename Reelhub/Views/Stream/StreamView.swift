//
//  StreamView.swift
//  Reelhub
//
//  Created by Teddy Moussignac on 12/9/21.
//

import SwiftUI

struct StreamView: View {
    @EnvironmentObject var store: StreamDetailedStore
    @State private var posX: CGFloat = 0
    @State private var scrollPosition: CGPoint = .zero
    @State private var scrollTop: CGFloat = 0
    
    var body: some View {
        GeometryReader { geometry in
            let screenSize = geometry.size
            /// Base on 27×40-inch posters
            /// Movie poster width is 67.5% of its height
            // let cardWidth = screenSize.width / 1.2
            let posterHeight = screenSize.width / 0.675 // Movie posters are width is 67.5% of its height
            // Content overlay container
            ZStack(alignment: .top) {
                // Collection view link
                // Poster or Title
                VStack {
                    if (!store.poster.isEmpty) {
                        // Poster view
                        ImageView(url: store.poster)
                            .frame(height: posterHeight)
                            .cornerRadius(.radiusLarge)
                            .scaleEffect(1 + (scrollPosition.y / 10000), anchor: .center)
                    } else {
                        // Title text view
                        Text(store.title)
                            .font(.largeTitle)
                            .fontWeight(.black)
                            .frame(height: posterHeight)
                            .multilineTextAlignment(.center)
                            .padding()
                    }
                }
                
                // Content
                ScrollView(.vertical, showsIndicators: false) {
                    VStack {
                        Color.clear
                            .frame(width: screenSize.width, height: scrollTop)
                        
                        StreamContent()
                            .padding(.horizontal)
                            .padding(.bottom, .large)
                            .background(.black)
                            .cornerRadius(.radiusLarge)
                            .shadow(color: .black.opacity(0.75), radius: 15)
                    }
                    .background(GeometryReader { geometry in
                        Color.clear
                            .preference(key: ScrollOffsetPreferenceKey.self, value: geometry.frame(in: .named("scroll")).origin)
                    })
                    .onPreferenceChange(ScrollOffsetPreferenceKey.self) { value in
                        self.scrollPosition = value
                    }
                }
                .coordinateSpace(name: "scroll")
            }
            .colorScheme(.dark)
            .navigationBarTitle(Text(""), displayMode: .inline)
            .task {
                if store.fetching {
                    store.showProgressView = true
                 }
                
                // Set initial height.
                if UIDevice().userInterfaceIdiom == .phone {
                    if UIScreen.main.nativeBounds.height >= 2688 { // large screens
                        scrollTop = posterHeight - .large
                    } else {
                        scrollTop = posterHeight - (.xlarge + .medium )
                    }
                }
            }
        }
    }
}

extension StreamView {
    struct ScrollOffsetPreferenceKey: PreferenceKey {
        static var defaultValue: CGPoint = .zero
        static func reduce(value: inout CGPoint, nextValue: () -> CGPoint) {}
    }
}

/// Preview
struct StreamView_Previews: PreviewProvider {
    static var previews: some View {
        let streams = [Stream]()
        let stream = streams.randomElement()!
        let store = StreamDetailedStore(stream: stream)
        StreamView()
            .environmentObject(store)
            .colorScheme(.dark)
    }
}
