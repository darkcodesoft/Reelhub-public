//
//  Person.swift
//  
//
//  Created by Teddy Moussignac on 12/28/21.
//

import Foundation
import Vapor
import PackStream

typealias Model = Content & Hashable & Codable & Identifiable

extension Stream {

    struct Person: Model {
        var id: Int
        var name: String
        
        static let KEY = Neo4jService.Node.Person.key
        static let MATCH = Neo4jService.Node.Person.match
        
        enum NODE: String {
            case Cast
            case Staff
        }
        
        ///
        ///
        ///
        public static func search (keyword: String) async -> [Person] {
            let dbService = Neo4jService(host: .stream)
            let query = """
            CALL db.index.fulltext.queryNodes('person_index', "\(keyword)") YIELD node
            RETURN
                id(node) as id,
                node.name as name
            """
            do {
                let persons: [Person]? = try await dbService.run(query)
                return persons!
            } catch {
                return []
            }
        }
        
        /// Fetch for `Service` items.
        ///
        /// - Parameters:
        ///   - isOn: List of id to set to on by default
        public static func fetch (stream: Stream? = nil, person: Person? = nil, relationship: Relationship? = nil) async -> [Person] {
            let dbService = Neo4jService(host: .stream)
            var cypher = """
            \(MATCH)--(\(Stream.KEY):\(Stream.NODE))
            RETURN
                \(KEY).id as id,
                \(KEY).name as name
            """
            
            if let stream = stream, let relationship = relationship {
                cypher = """
                \(MATCH)-[\(relationship.key):\(relationship.rawValue)]-(\(Stream.KEY):\(Stream.NODE) { slug: "\(stream.slug!)" })
                RETURN
                    id(\(KEY)) as id,
                    \(KEY).name as name
                """
            }
                
            do {
                print(cypher)
                let persons: [Person]? = try await dbService.run(cypher)
                return persons!
            } catch {
                return []
            }
        }
    }
}

extension Stream.Person {
    enum Relationship: String, CaseIterable {
        case ACTED_IN
        case WORKED_ON
        
        var key: String { ["\(rawValue.first!)", "\(rawValue.last!)"].joined().lowercased() }
    }
}
