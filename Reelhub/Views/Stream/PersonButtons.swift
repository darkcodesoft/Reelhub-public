//
//  PersonButtons.swift
//  Reelhub
//
//  Created by Teddy Moussignac on 1/14/22.
//

import SwiftUI

struct PersonButtons: View {
    var items: [Stream.Person]
    
    @State private var store: CollectionStore? = nil
    @State private var navigationLinkIsActive = false
    
    var body: some View {
        ZStack {
            /// Genre Collection NavigationLink.
            NavigationLink(
                destination: CollectionView().environmentObject(store ?? .init()),
                isActive: $navigationLinkIsActive
            ) { EmptyView().frame(width: 0, height: 0) }
            LazyVGrid(columns: Array(repeating: .init(.flexible(), spacing: .small), count: 2)) {
                ForEach(items, id: \.self) { person in
                    Button(action: {
                        navigateTo(person: person)
                    }, label: {
                        HStack {
                            Spacer()
                            Text(person.name)
                                .font(.small)
                                .foregroundColor(.appPrimary)
                                .lineLimit(2)
                                .padding(.vertical)
                            Spacer()
                        }
                        .background(Color.appGray)
                        .cornerRadius(.radiusMedium)
                    })
                }
            }
        }
    }
    
    /// Set current `StreamDetailedStore`.
    ///
    /// - Parameters:
    ///   - stream: stream item
    func navigateTo (person: Stream.Person) {
        Task.init {
            store = await CollectionStore(person: person)
            navigationLinkIsActive = true
        }
    }
}

struct PersonButtons_Previews: PreviewProvider {
    static var previews: some View {
        let streams = [Stream]()
        let stream = streams.randomElement()!
        PersonButtons(items: stream.filmakers! + stream.cast!)
            .colorScheme(.dark)
    }
}
