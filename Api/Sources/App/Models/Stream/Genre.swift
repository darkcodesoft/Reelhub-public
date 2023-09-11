//
//  File.swift
//  
//
//  Created by Teddy Moussignac on 12/28/21.
//

import Foundation
import Vapor
import PackStream

extension Stream {

    struct Genre: Content, Codable, Hashable {
        var id: Int
        var name: String
        var isOn: Bool?
        
        static let NODE = Neo4jService.Node.Genre.rawValue
        static let KEY = Neo4jService.Node.Genre.key
        static let MATCH = Neo4jService.Node.Genre.match
        
        /// Fetch for `Genre` items.
        ///
        /// - Parameters:
        ///   - isOn: List of id to set to on by default
        public static func fetch (genre: Genre? = nil, stream: Stream? = nil, isOn: [Int]? = nil) async -> [Genre] {
           let dbService = Neo4jService(host: .stream)
            
            // get all available genres
            var cypher = """
            \(MATCH)
            RETURN
                \(KEY).id as id,
                \(KEY).name as name
            """
             
            // get all genres for stream
            if let stream = stream {
                cypher = """
                \(MATCH)--(\(Stream.KEY):\(Stream.NODE) { slug: "\(stream.slug!)" })
                RETURN
                    \(KEY).id as id,
                    \(KEY).name as name
                """
            }
            
            do {
                let genres: [Genre]? = try await dbService.run(cypher)
                return genres!.map {
                    var genre = $0
                    if let isOn = isOn {
                        genre.isOn = isOn.contains(genre.id)
                    } else {
                        genre.isOn = true
                    }
                    return genre
                }
            } catch {
                return []
            }
        }
    }
}
