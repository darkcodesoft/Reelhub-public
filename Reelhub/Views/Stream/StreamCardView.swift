//
//  StreamCard.swift
//  Reelhub
//
//  Created by Teddy Moussignac on 3/26/23.
//

import SwiftUI

// Card View definition
struct StreamCardView: View {
    @EnvironmentObject var store: StreamCardStore
    @EnvironmentObject var userStore: UserStore
    
    @State private var streamStore: StreamDetailedStore? = nil
    @State private var collectionStore: CollectionStore? = nil
    @State private var streamNavigationLinkIsActive = false
    @State private var navigationLinkIsActive = false
    
    var body: some View {
        GeometryReader { geometry in
            let screenSize = geometry.size
            /// Base on 27×40-inch posters
            /// Movie posters are width is 67.5% of its height
            let cardWidth = screenSize.width / 1.2
            let cardHeight = cardWidth / 0.675 // 35% screen height
            
            ZStack {
                
                /// Stream NavigationLink.
                NavigationLink(
                    destination: StreamView().environmentObject(streamStore ?? .init()).environmentObject(store),
                    isActive: $streamNavigationLinkIsActive
                ) { EmptyView().frame(width: 0, height: 0) }
                
                // Shared NavigationLink.
                NavigationLink(
                    destination: CollectionView().environmentObject(collectionStore ?? .init()),
                    isActive: $navigationLinkIsActive
                ) { EmptyView().frame(width: 0, height: 0) }
                
                // Blurred background
                VStack {
                    ImageView(url: store.stream.posterHD.count > 0 ? store.stream.posterHD : store.stream.poster)
                        .frame(width: screenSize.width, height: screenSize.width / 0.675)
                        .blur(radius: 20)
                        .opacity(0.5)
                    
                    Spacer()
                }
                
                // Dividers
                VStack {
                    Rectangle()
                        .fill(
                            LinearGradient(gradient: Gradient(colors: [.black, .clear]), startPoint: .top, endPoint: .bottom)
                        )
                        .frame(height: screenSize.height / 8)
                    Spacer()
                }
                    
                // Body
                LazyVStack {
                    // MARK: Poster
                    ImageView(url: store.stream.posterHD.count > 0 ? store.stream.posterHD : store.stream.poster)
                        .frame(width: cardWidth, height: cardHeight)
                        .cornerRadius(.radiusMedium)
                        .overlay(
                            RoundedRectangle(cornerRadius: .radiusMedium)
                                .stroke(Color.appGray, style: StrokeStyle(lineWidth: 1))
                        )
                        .clipped()
                        .onTapGesture {
                            navigateTo(stream: store.stream)
                        }
                    
                    Spacer()
                    
                    // MARK: Content
                    VStack(alignment: .leading) {
                        // Meta
                        HStack {
                            // Year Text
                            Text(store.stream.year!.description)
                                .foregroundColor(.gray.opacity(0.8))
                            // Type Button
                            Button( action: {
                                navigateTo(type: store.stream.type ?? .movie)
                            }, label: {
                                Text(Stream.Types(rawValue: store.stream.type ?? .movie)?.rawName ?? "")
                            })
                            .buttonStyle(.plain)
                            
                            Spacer()
                            
                            // User buttons
                            HStack {
                                // Like Button
                                Button(action: {
                                    if UserStore.shared.isLoggedIn {
                                        store.stream.liked?.toggle()
                                    } else {
                                        // Render Login view
                                        userStore.showLoginView.toggle()
                                    }
                                }, label: {
                                    Image(systemName: "heart.fill")
                                        .resizable()
                                        .frame(width: .iconHeartWidth, height: .iconHeartHeight)
                                        .tint((store.stream.liked ?? false) ? .red : .appPrimary)
                                })
                                .padding(.trailing)
                                
                                // Bookmark Button
                                Button(action: {
                                    if UserStore.shared.isLoggedIn {
                                        store.stream.bookmarked?.toggle()
                                    } else {
                                        // Render Login view
                                        userStore.showLoginView.toggle()
                                    }
                                }, label: {
                                    Image(systemName: "bookmark.fill")
                                        .resizable()
                                        .frame(width: .iconBookmarkWidth, height: .iconBookmarkHeight)
                                        .tint((store.stream.bookmarked ?? false) ? .yellow : .appPrimary)
                                })
                                .padding(.trailing)
                                
                                // Watched Button
                                Button(action: {
                                    if UserStore.shared.isLoggedIn {
                                        store.stream.watched?.toggle()
                                    } else {
                                        // Render Login view
                                        UserStore.shared.showLoginView.toggle()
                                    }
                                }, label: {
                                    Image(systemName: "checkmark.circle.fill")
                                        .resizable()
                                        .frame(width: .iconHeartWidth, height: .iconHeartWidth)
                                        .tint((store.stream.watched ?? false) ? .green : .appPrimary)
                                })
                            }
                        }
                        .font(.small)
                        .padding(.vertical)
                        
                        // Services
                        if let services = store.stream.services, services.count > 0 {
                            HStack {
                                ServiceButtons(items: [services.first!])
                                    .padding(.bottom)
                                    .frame(alignment: .trailing)
                            }
                        }
                            
                        // Genre grid
                        HStack {
                            ForEach(store.genres, id: \.self) { genre in
                                Button(action: {
                                    navigateTo(genre: genre)
                                }, label: {
                                    Text(genre.tag)
                                        .font(.small)
                                        .foregroundColor(.appPrimary)
                                })
                                .padding(.trailing, .xsmall)
                            }
                        }
                    }
                    .frame(width: cardWidth)
                }
                
                // Film Strips
                HStack {
                    FilmStripView()
                    Spacer()
                    FilmStripView()
                }
                .frame(height: screenSize.height)
             }
            .clipped()
        }
    }
    
    /// Set current `StreamDetailedStore`.
    ///
    /// - Parameters:
    ///   - stream: stream item
    func navigateTo (stream: Stream? = nil, type: String? = nil, genre: Stream.Genre? = nil) {
        // Navigate to stream detail
        if let stream = stream {
            streamStore = StreamDetailedStore(stream: stream, referred: true)
            streamNavigationLinkIsActive = true
        }
        // Navigate to type collection
        if let type = type {
            collectionStore = CollectionStore(type: type)
            navigationLinkIsActive = true
        }
        // Navigate to genre collection
        if let genre = genre {
            collectionStore = CollectionStore(genres: [genre], service: store.stream.services?.first)
            navigationLinkIsActive = true
        }
        
    }
}

struct StreamCardView_Previews: PreviewProvider {
    static var previews: some View {
        StreamCardView()
    }
}
