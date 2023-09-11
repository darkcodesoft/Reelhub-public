//
//  StreamCardStore.swift
//  Reelhub
//
//  Created by Teddy Moussignac on 4/17/23.
//

import Foundation

final class StreamCardStore: ObservableObject {
    @Published var stream: Stream
    
    init(stream: Stream) {
        self.stream = stream
    }
    
    /// Get sliced genres
    var genres: [Stream.Genre] {
        if let genres = stream.genres {
            let sliced: [Stream.Genre] = genres.count >= 3 ? Array(genres[0..<3]) : genres
            return sliced
        }
        return []
    }
}
