//
//  SocialButtons.swift
//  Reelhub
//
//  Created by Teddy Moussignac on 1/14/22.
//

import SwiftUI

struct SocialButtons: View {
    @EnvironmentObject var store: StreamDetailedStore
    @EnvironmentObject var card: StreamCardStore
    
    var referred = false
    var stream: Stream { !referred ? store.stream! : card.stream }
    
    var body: some View {
        Group {
            // Like Button
            Button(action: {
                if UserStore.shared.isLoggedIn {
                    likedToggle()
                } else {
                    // Render Login view
                    UserStore.shared.showLoginView.toggle()
                }
            }, label: {
                Image(systemName: "heart.fill")
                    .resizable()
                    .frame(width: .iconHeartWidth, height: .iconHeartHeight)
                    .tint((stream.liked ?? false) ? .red : .appPrimary)
            })
            .padding(.trailing)
            
            // Bookmark Button
            Button(action: {
                if UserStore.shared.isLoggedIn {
                    bookmarkedToggle()
                } else {
                    // Render Login view
                    UserStore.shared.showLoginView.toggle()
                }
            }, label: {
                Image(systemName: "bookmark.fill")
                    .resizable()
                    .frame(width: .iconBookmarkWidth, height: .iconBookmarkHeight)
                    .tint((stream.bookmarked ?? false) ? .yellow : .appPrimary)
            })
            .padding(.trailing)
            
            // Watched Button
            Button(action: {
                if UserStore.shared.isLoggedIn {
                    watchedToggle()
                } else {
                    // Render Login view
                    UserStore.shared.showLoginView.toggle()
                }
            }, label: {
                Image(systemName: "checkmark.circle.fill")
                    .resizable()
                    .frame(width: .iconHeartWidth, height: .iconHeartWidth)
                    .tint((stream.watched ?? false) ? .green : .appPrimary)
            })
        }
    }
    
    // liked toggle action
    func likedToggle() {
        if !referred {
            store.stream?.liked?.toggle()
        } else {
            card.stream.liked?.toggle()
        }
    }
    
    // bookmarked toggle action
    func bookmarkedToggle() {
        if !referred {
            store.stream?.bookmarked?.toggle()
        } else {
            card.stream.bookmarked?.toggle()
        }
    }
    
    // watched toggle action
    func watchedToggle() {
        if !referred {
            store.stream?.watched?.toggle()
        } else {
            card.stream.watched?.toggle()
        }
    }
}

struct SocialGroup_Previews: PreviewProvider {
    static var previews: some View {
        let streams = [Stream]()
        let stream = streams.randomElement()!
        let store = StreamDetailedStore(stream: stream)
        let card = StreamCardStore(stream: stream)
        SocialButtons()
            .environmentObject(store)
            .environmentObject(card)
            .colorScheme(.dark)
    }
}
