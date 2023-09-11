//
//  StreamCarouselView.swift
//  Reelhub
//
//  Created by Teddy Moussignac on 2/22/22.
//

import SwiftUI

struct StreamCarouselView: View {
    @Environment(\.screenSize) var screenSize

    var items: [Stream]

    @State private var store: StreamDetailedStore? = nil
    @State private var navigationLinkIsActive = false

    var cardWidth: CGFloat {
        screenSize.width / 2.25
    }

    var cardHeight: CGFloat {
        cardWidth * 0.59
    }

    var body: some View {
        ZStack {
            /// Shared NavigationLink.
            NavigationLink(
                destination: StreamView().environmentObject(store ?? .init()),
                isActive: $navigationLinkIsActive
            ) { EmptyView().frame(width: 0, height: 0) }

            ScrollView(.horizontal, showsIndicators: false) {
                LazyHGrid(rows: [GridItem(.flexible(maximum: cardWidth))], alignment: .top) {
                    ForEach(items) { stream in
                        Button(action: {
                            navigateTo(stream: stream)
                        }, label: {
                            VStack(alignment: .leading) {
                                // Wallpaper
                                ImageView(url: stream.wallpaper)
                                    .frame(width: cardWidth, height: cardHeight)
                                    .cornerRadius(.radiusSmall)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: .radiusSmall)
                                            .stroke(Color.appGray, style: StrokeStyle(lineWidth: 1))
                                            .foregroundColor(.clear)
                                    )
                                    .padding(.bottom, 0.5)
                                
                                // Title
                                Text(stream.title)
                                    .fontWeight(.bold)
                                    .font(.small)
                                    .lineLimit(2)
                                    .multilineTextAlignment(.leading)
                                    .frame(width: cardWidth, alignment: .leading)
                                    .foregroundColor(.primary)
                                    .padding(.bottom, 0.5)
                                
                                // Meta
                                if let year = stream.year, let type = stream.type {
                                    HStack {
                                        Text(year.description)
                                            .font(.xsmall)
                                        Text(Stream.Types(rawValue: type)?.rawName.localizedUppercase ?? "")
                                            .font(.xsmall)
                                    }
                                    .foregroundColor(.gray)
                                }
                                
                                // Spacer
                                Spacer()
                            }
                        })
                            .tint(.clear)
                    }
                }
                .padding(.bottom)
                .padding(.horizontal)
            }
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

struct StreamCarouselView_Previews: PreviewProvider {
    static var previews: some View {
        let streams: [Stream] = []
        GeometryReader {geometry in
            StreamCarouselView(items: streams)
                .environment(\.colorScheme, .dark)
                .environment(\.screenSize, EnvironmentValues.ScreenSize(width: geometry.size.width, height: geometry.size.height))
        }
    }
}
