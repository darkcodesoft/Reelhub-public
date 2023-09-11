//
//  Service.swift
//  
//
//  Created by Teddy Moussignac on 12/28/21.
//

import Foundation
import Vapor
import PackStream

extension Stream {

    struct Service: Content, Hashable, Codable {
        var id: Int
        var name: String
        var added: String?
        var leaving: String?
        var link: String?
        var isOn: Bool?
        
        static let NODE = Neo4jService.Node.Service.rawValue
        static let KEY = Neo4jService.Node.Service.key
        static let MATCH = Neo4jService.Node.Service.match
        
        /// Fetch for `Service` items.
        ///
        /// - Parameters:
        ///   - isOn: List of id to set to on by default
        public static func fetch (service: Service? = nil, stream: Stream? = nil, isOn: [String]? = nil) async -> [Service] {
            let dbService = Neo4jService(host: .stream)
            
            // get all available services
            var cypher = """
            \(MATCH)
            RETURN
                id(\(KEY)) as id,
                \(KEY).name as name
            """
            
            // get all services for stream
            if let stream = stream {
                cypher = """
                \(MATCH)<-[a:AVAILABLE]-(\(Stream.KEY):\(Stream.NODE) { slug: "\(stream.slug!)" })
                RETURN
                    id(\(KEY)) as id,
                    \(KEY).name as name,
                    a.added as added,
                    a.leaving as leaving,
                    a.link as link
                """
            }
            
            do {
                let services: [Service]? = try await dbService.run(cypher)
                return services!.map {
                    var service = $0
                    if let isOn = isOn {
                        service.isOn = isOn.contains(service.name)
                    } else {
                        service.isOn = true
                    }
                    return service
                }
            } catch {
                return []
            }
        }
   }
}
