//
//  StreamContent.swift
//  Reelhub
//
//  Created by Teddy Moussignac on 1/14/22.
//

import SwiftUI

struct StreamContent: View {
    @EnvironmentObject var store: StreamDetailedStore
    @State private var navigationLinkIsActive = false
    @State private var webViewLinkIsActive = false
    @State private var webViewStore: WebViewStore? = nil
    @Environment(\.screenSize) var screenSize
    
    var body: some View {
        VStack {
            /// Scroll up indicator.
            HStack {
                Spacer()
                Rectangle()
                    .frame(width: screenSize.width/4, height: 4)
                    .foregroundColor(.clear)
                    .background(.gray.opacity(0.5))
                    .cornerRadius(4)
                Spacer()
            }
            .padding(.top, .xsmall)
            
            HStack {
                // Year + Type
                HStack {
                    // Year Text
                    Text(store.year > 0 ? store.year.description : "")
                        .foregroundColor(.gray.opacity(0.8))
                    // Type Button
                    Button( action: {
                        store.collection = CollectionStore(type: store.type)
                        navigationLinkIsActive = true
                    }, label: {
                        Text(Stream.Types(rawValue: store.type)?.rawName ?? "")
                    })
                    .buttonStyle(.plain)
                }
                .font(.small)
                
                Spacer()
                // Like + Follow buttons
                SocialButtons(referred: store.referred)
            }
            .padding(.top, .xsmall*2)
            .padding(.bottom)
            .padding(.horizontal)
            
            // Bottom content + ProgressView container
            ZStack(alignment: .top) {
                // Collection NavigationLink.
                NavigationLink(
                    destination: CollectionView().environmentObject(store.collection),
                    isActive: $navigationLinkIsActive
                ) { EmptyView().frame(width: 0, height: 0) }
                
                // WebView NavigationLink.
                NavigationLink(
                    destination: WebView().environmentObject(webViewStore ?? .init()),
                    isActive: $webViewLinkIsActive
                ) { EmptyView().frame(width: 0, height: 0) }
                // Bottom content
                VStack(alignment: .leading) {
                    // Service buttons
                    ServiceButtons(items: store.services)
                        .padding(.bottom)
                    
                    // Genre buttons
                    Text(String.genres)
                        .fontWeight(.black)
                        .foregroundColor(.appAccent)
                    GenreButtons(items: store.genres)
                        .padding(.bottom)
                    
                    // Overview
                    if store.overview.count > 0 {
                        Text(String.overview)
                            .fontWeight(.black)
                            .foregroundColor(.appAccent)
                        HStack {
                            Text(store.overview)
                                .font(.small)
                                .lineLimit(store.expandOverview ? nil : 3)
                                .multilineTextAlignment(.leading)
                                .padding()
                            Spacer()
                        }
                        .background(Color.appGray)
                        .cornerRadius(.radiusMedium)
                        .padding(.bottom)
                        .onTapGesture {
                            withAnimation {
                                store.expandOverview.toggle()
                            }
                        }
                    }
                    
                    // Directors
                    if let filmakers = store.stream?.filmakers {
                        Text(String.directors)
                            .fontWeight(.black)
                            .foregroundColor(.appAccent)
                        PersonButtons(items: filmakers)
                            .padding(.bottom)
                    }
                    
                    // Cast
                    if let cast = store.stream?.cast {
                        Text(String.cast)
                            .fontWeight(.black)
                            .foregroundColor(.appAccent)
                        PersonButtons(items: cast)
                            .padding(.bottom)
                    }
                    
                    // Video
                    if let stream = store.stream, let _ = store.stream?.video {
                        Text(String.trailer)
                            .fontWeight(.black)
                            .foregroundColor(.appAccent)
                        ZStack {
                            ImageView(url: stream.wallpaper)
                                .blur(radius: 10)
                                .cornerRadius(.radiusMedium)
                                .opacity(0.75)
                                .overlay(
                                    RoundedRectangle(cornerRadius: .radiusMedium)
                                        .stroke(Color.appGray, style: StrokeStyle(lineWidth: 1))
                                )
                                .clipped()
                            
                            VStack {
                                Spacer()
                                Image(systemName: "play.fill")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 40, height: 40)
                                    .shadow(color: .black.opacity(0.5), radius: 30)
                                Spacer()
                            }
                        }
                        .padding(.bottom)
                        .onTapGesture {
                            if UserStore.shared.isLoggedIn {
                                loadTrailer()
                            } else {
                                // Render Login view
                                UserStore.shared.showLoginView.toggle()
                            }
                        }
                    }
                    
                    // Title
                    HStack {
                        Spacer()
                        Text(store.title)
                            .fontWeight(.black)
                            .foregroundColor(.appGray)
                            .lineLimit(2)
                            .multilineTextAlignment(.center)
                        Spacer()
                    }
                    .padding()
                    .padding(.top, .small)
                }
                .padding(.horizontal)
                .opacity(store.showContent == true ? 1 : 0)
                
                // ProgressView
                if (store.fetching && store.showProgressView) {
                    VStack {
                        ProgressView()
                        Spacer()
                    }
                }
            }
        }
    }
    
    ///
    func loadTrailer () {
        if let url = store.trailerUrl {
            webViewStore = .init(url: url)
            webViewLinkIsActive = true
        }
    }
}

struct StreamContent_Previews: PreviewProvider {
    static var previews: some View {
        let streams = [Stream]()
        let stream = streams.randomElement()!
        let store = StreamDetailedStore(stream: stream)
        let user = UserStore()
        StreamContent()
            .environmentObject(store)
            .environmentObject(user)
            .colorScheme(.dark)
    }
}
