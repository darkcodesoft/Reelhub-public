//
//  StreamCellView.swift
//  Reelhub
//
//  Created by Teddy Moussignac on 12/13/21.
//

import SwiftUI

struct StreamCellView: View {
    @Environment(\.screenSize) var screenSize
    let stream: Stream

    /// Base on 27×40-inch posters
    /// Movie posters are width is 67.5% of its height
    var gridWidth: CGFloat {
        screenSize.width / 2 - .medium
    }

    var gridHeight: CGFloat {
        gridWidth / 0.675 // 35% screen height
    }

    var body: some View {
        VStack(alignment: .leading) {
            // Poster
            ImageView(url: stream.poster)
                .frame(width: gridWidth, height: gridHeight)
                .foregroundColor(.gray.opacity(0.5))
                .cornerRadius(.radiusMedium)
                .overlay(
                    RoundedRectangle(cornerRadius: .radiusMedium)
                        .stroke(Color.appGray, style: StrokeStyle(lineWidth: 1))
                )
                .clipped()
                .padding(.bottom, .xsmall)
            
            // Title
            Text(stream.title)
                .fontWeight(.bold)
                .font(.small)
                .lineLimit(2)
                .multilineTextAlignment(.leading)
                .padding(.bottom, 0.5)
            
            // Meta
            if let year = stream.year, let type = stream.type {
                HStack {
                    Text(year.description)
                        .font(.xsmall)
                    Text(type.localizedUppercase)
                        .font(.xsmall)
                }
                .foregroundColor(.gray)
            }
            
            // Spacer
            Spacer()
        }
    }
}

struct StreamCellView_Previews: PreviewProvider {
    static var previews: some View {
        let streams = [Stream]()
        let stream = streams.randomElement()!
        StreamCellView(stream: stream)
            .environment(\.colorScheme, .dark)
    }
}
