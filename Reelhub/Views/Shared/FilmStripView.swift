//
//  FilmStripView.swift
//  Reelhub
//
//  Created by Teddy Moussignac on 3/27/23.
//

import SwiftUI

struct FilmStripView: View {
    @State private var yoffset = 0.0
    
    var body: some View {
        GeometryReader { geometry in
            Image("filmStrip")
                .offset(y: yoffset)
                .padding(0)
                .opacity(0.8)
                .frame(width: 15)
                .animation(Animation.linear(duration: 4).repeatForever(autoreverses: false), value: yoffset)
                .task {
                    withAnimation {
                        yoffset = -(geometry.size.height / 4)
                    }
                }
        }
        .frame(width: 15)
    }
}

struct FilmStripView_Previews: PreviewProvider {
    static var previews: some View {
        FilmStripView()
    }
}
