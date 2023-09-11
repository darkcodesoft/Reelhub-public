//
//  Neo4jService.swift
//  
//
//  Created by Teddy Moussignac on 11/11/21.
//

import Foundation
import Vapor
import PackStream
import Theo

/// Neo4j Graph DB Service
class Neo4jService {
    var client: BoltClient?
    var status: Result<Bool, Error>?
    
    /// Creates a variable of self with a default database
    /// Initiate `BoltClient` instace with credentials.
    init (host: Host) {
        let config: Dictionary<String, String> = [
            "hostname": host.url,
            "port": Environment.get("NEO4J_PORT") ?? "",
            "username": Environment.get("NEO4J_USER") ?? "",
            "password": Environment.get("NEO4J_PASSWORD") ?? "",
            "encrypted": "true"
        ]

        if let client = try? BoltClient(JSONClientConfiguration(json: config)) {
            self.client = client
            status = self.client!.connectSync()
        }
    }
    
    /// Decodable Run query.
    ///
    ///
    func run <T:Codable>(_ query: String, params: [String: PackProtocol] = [:]) async throws -> [T] {
        do {
            let results = try await execute(query, params: params)
            let data = try JSONSerialization.data(withJSONObject: results)
            let models = try JSONDecoder().decode(Array<T>.self, from: data)
            return models
        } catch let error {
            print(error)
            return []
        }
    }
    
    /// Run query.
    ///
    /// - Parameters:
    ///   - query: query string.
    ///   - Returns NSDictionary array of key value params.
    func execute (_ query: String, params: [String: PackProtocol] = [:]) async throws -> [NSDictionary] {
        return try await withCheckedThrowingContinuation { (continuation: CheckedContinuation<[NSDictionary], Error>) in
            switch status {
            case let .failure(error):
                    continuation.resume(throwing: error)
            default:
                let result: Result<QueryResult, Error> = client!.executeCypherSync(query, params: params)
                switch result {
                case let .failure(error):
                    continuation.resume(throwing: error)
                case let .success(success):
                    let rows = success.rows as [NSDictionary]
                    continuation.resume(returning: rows)
                }
            }
        }
    }
    
    ///
    ///
    ///
    deinit {
        client?.disconnect()
    }
}

extension Neo4jService {
    /// DB Hosts
    enum Host: String {
        case stream
        case user
        
        var url: String {
            let key = "NEO4J_\(self.rawValue.uppercased())_HOST"
            return Environment.get(key) ?? ""
        }
    }
    
    /// Nodes
    enum Node: String, Codable {
        case Age
        case User
        case Genre
        case Person
        case Cast
        case Staff
        case Service
        case Rating
        case Stream
        case Kind = "Type"
        case Year
        
        var key: String { ["\(rawValue.first!)", "\(rawValue.last!)"].joined().lowercased() }
        
        var index: String { "(\(key):\(rawValue))" }
        
        var match: String { "MATCH \(index)" }
    }
    
    ///
    struct Query: Content, Codable {
        var id: Int?
        var page: Int?
        var type: String?
        var genres: [Int]?
        var section: String?
        var weight: Int?
        var services: [String]?
        var person: String?
        var order: String?
        var limit: Int?
        var keyword: String?
        var uid: String?
    }
    // Segment
    struct Segment: Codable, Content {
        let name: String
        let from: Neo4jService.Node?
        let to: Neo4jService.Node?
    }
    
    //
    struct Item: Codable, Content {
        let title: String
        let year: Int
    }
    
    //
    struct Response: Codable, Content {
        let items: [Item]
    }
     
    /// Creates `Object` constants from `PackStream.List`.
    ///
    /// - Parameters:
    ///   - list: `PackStream`
    static func modelsFromPackStreamList <T:Codable>(list: PackStream.List) throws -> [T] {
        let dictionnaries = list.items.map { (pack: PackProtocol) -> Dictionary<String, Any> in
            if let pack = pack as? Map {
                return pack.dictionary
            }
            return [:]
        }
        let data = try JSONSerialization.data(withJSONObject: dictionnaries)
        let models = try JSONDecoder().decode(Array<T>.self, from: data)
        return models
    }
}
