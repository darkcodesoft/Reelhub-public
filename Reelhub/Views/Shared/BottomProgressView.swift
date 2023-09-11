//
//  BottomProgressView.swift
//  Reelhub
//
//  Created by Teddy Moussignac on 2/22/22.
//

import SwiftUI

struct BottomProgressView: View {
    var count: Int
    var fetching: Bool

    var body: some View {
        VStack {
            if (count >= Cloud.Response.limit) {
                HStack {
                    Spacer()
                    ProgressView()
                        .padding(.vertical, .medium)
                        .opacity(fetching == true ? 1 : 0)
                    Spacer()
                }
            } else {
                Color.clear
                    .padding(.bottom, .medium)
            }
        }
    }
}

struct BottomProgressView_Previews: PreviewProvider {
    static var previews: some View {
        BottomProgressView(count: Cloud.Response.limit, fetching: true)
    }
}
