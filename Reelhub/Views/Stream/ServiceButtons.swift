//
//  ServiceButtons.swift
//  Reelhub
//
//  Created by Teddy Moussignac on 1/2/22.
//

import SwiftUI

struct ServiceButtons: View {
    var items: [Stream.Service]

    var body: some View {
        LazyVGrid(columns: Array(repeating: .init(.flexible(), spacing: .small), count: 2)) {
            ForEach(items, id: \.self) {service in
                if let link = service.link {
                    Link(destination: URL(string: link)!) {
                        HStack {
                            Spacer()
                            Image(systemName: "play.fill")
                                .resizable()
                                .frame(width: .fontSizeizeSmall, height: .fontSizeizeSmall)
                            Text(service.fullName)
                                .font(.small)
                                .fontWeight(.bold)
                                .padding(.vertical)
                            Spacer()
                        }
                    }
                    .tint(service.theme.secondary)
                    .background(service.theme.primary)
                    .foregroundColor(service.theme.foreground)
                    .cornerRadius(.radiusMedium)
                }
            }
        }
    }
}

struct ServiceButtons_Previews: PreviewProvider {
    static var previews: some View {
        ServiceButtons(items: [])
            .colorScheme(.dark)
    }
}
