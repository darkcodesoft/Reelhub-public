//
//  ImageView.swift
//  Reelhub
//
//  Created by Teddy Moussignac on 12/22/21.
//

import SwiftUI

struct ImageView: View {
    var url: String
    var animated = true
    var showsProgressView = false

    @State private var progressViewIsHidden = true
    @State private var opacity: CGFloat = 0

    var body: some View {
     /// Load network image async.
        AsyncImage(
            url: URL(string: url),
            transaction: Transaction(animation: (animated || !progressViewIsHidden) ? .easeInOut : .none)
        ) { phase in
            switch phase {
            case .empty:
                if showsProgressView && !progressViewIsHidden {
                    ProgressView()
                } else {
                    Color.clear
                }
            case .success(let image):
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .task {
                        // Hide progress view.
                        progressViewIsHidden = false
                        withAnimation { opacity = 1 }
                    }
            case .failure:
                Color.clear
            @unknown default:
                Color.clear
            }
        }
        .opacity(opacity)
        .background(Color.appImageGray)
    }
}

struct ImageView_Previews: PreviewProvider {
    static var previews: some View {
        let streams = [Stream]()
        let stream = streams.randomElement()
        ImageView(url: stream!.poster)
    }
}
