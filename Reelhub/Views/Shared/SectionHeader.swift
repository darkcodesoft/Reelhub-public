//
//  SectionHeader.swift
//  Reelhub
//
//  Created by Teddy Moussignac on 1/27/22.
//

import SwiftUI

struct SectionHeader: View {
    var title: String
    var body: some View {
        Text(title)
            .font(.large)
            .fontWeight(.black)
    }
}

struct SectionHeader_Previews: PreviewProvider {
    static var previews: some View {
        SectionHeader(title: "Watch Now")
    }
}
