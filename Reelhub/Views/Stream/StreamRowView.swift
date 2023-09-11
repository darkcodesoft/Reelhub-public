//
//  StreamRowView.swift
//  Reelhub
//
//  Created by Teddy Moussignac on 2/13/22.
//

import SwiftUI

struct StreamRowView: View {
    var stream: Stream

    var body: some View {
        LazyVStack {
            HStack {
                ImageView(url: stream.wallpaper)
                    .frame(width: 100, height: 56)
                    .cornerRadius(.radiusSmall)
                    .padding(.vertical, .xsmall)
                Text(stream.title)
                    .font(.headline)
                    .padding(.leading, .medium)
                Spacer()
                Image(systemName: "chevron.right")
                    .foregroundColor(.gray)
            }
            .clipped()
        }
    }
}

struct StreamRowView_Previews: PreviewProvider {
    static var previews: some View {
        let streams = [Stream]()
        let stream = streams.randomElement()!
        StreamRowView(stream: stream)
    }
}
