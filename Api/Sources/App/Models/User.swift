//
//  User.swift
//  Graph database Node definition
//  Document is stored FireStore and is used only by the client.
//
//  Created by Teddy Moussignac on 12/6/21.
//

import Foundation
import Vapor

struct User: Codable, Content {
    var uid = ""
    var username = ""
    
    /// Service
    static let NODE = Neo4jService.Node.User.rawValue
    static let KEY = Neo4jService.Node.User.key
    static let MATCH = Neo4jService.Node.User.match
    
    init(claims: User.Claims) {
        uid = claims.uid
        username = claims.username
    }
   
    /// Decode from Neo4j
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        uid = try container.decode(String.self, forKey: .uid)
        username = try container.decode(String.self, forKey: .username)
    }
    
    /// Get `User`
    ///
    /// - Parameters:
    ///   - user: `User`
    static func get (_ user: User) async -> User? {
        let query = """
        MATCH (u:User) WHERE u.uid = "\(user.uid)"
        RETURN u
        """
        
        do {
            // execute db query to user data
            // store details to user host
            let items: [User] = try await Neo4jService(host: .stream).run(query)
             // get stored user from db
            return items.first
        } catch {
            return nil
        }
    }
    
    /// Set `User`
    ///
    /// - Parameters:
    ///   - user: `User`
    static func set (_ user: User) async -> User? {
        var query = ""
        if let user = await User.get(user) {
            query = """
            MATCH (u:User) WHERE u.uid = "\(user.uid)"
            SET u.username = "\(user.username)"
            RETURN u
            """
        } else {
            query = """
            MERGE (u:User { uid: "\(user.uid)", username: "\(user.username)" })
            RETURN u
            """
        }
         do {
            // execute db query to user data
            // store details to user host
            let items: [User] = try await Neo4jService(host: .stream).run(query)
             // get stored user from db
            return items.first
        } catch {
            return nil
        }
    }
    
    /// Delete `User`
    ///
    /// - Parameters:
    ///   - user: `User`
    static func delete (_ user: User) async -> Bool {
        let query = """
        MATCH (u:User) WHERE u.uid = "\(user.uid)"
        OPTIONAL MATCH (u)-[r]-()
        DETACH DELETE u,r
        """
        
        do {
            // execute db query to delete user
            let service = Neo4jService(host: .stream)
            let _:[User] = try await service.run(query)
            return true
        } catch let error {
            print(error)
            return false
        }
    }
}

extension User {
    /// Claims Definition
    struct Claims: Codable, Content {
        var uid = ""
        var username = ""
    }
    
    ///
    enum Relationship: String, CaseIterable {
        case LIKED
        case BOOKMARKED
        case WATCHED
        case VIEWED
        
        var key: String { ["\(rawValue.first!)", "\(rawValue.last!)"].joined().lowercased() }
    }
}
