//
//  StreamController.swift
//  
//
//  Created by Teddy Moussignac on 10/31/21.
//

import Foundation
import Vapor

final class StreamController: Controller {
    /// Index
    ///
    public static func index (_ request: Request) async throws -> Response {
        do {
            var response = Response()
            if let query: Neo4jService.Query = try await Self.getClaims(request: request) {
                let streams = await Stream.fetch(query: query)
                // if detailed
                if let _ = query.id {
                    response.stream = streams.first
                } else {
                    response.streams = streams
                }
            } else {
                request.logger.error(.init(stringLiteral: .claimsDeocodingError))
            }
            return response
        } catch let error {
            // Return error
            request.logger.error(.init(stringLiteral: error.localizedDescription))
            return Response(error: error.localizedDescription)
        }
    }
    
    /// Settings endpoint
    /// Get service + genre lists.
    ///
    public static func settings (_ request: Request) async throws -> Response {
        var response = Response()
        response.genres = await Stream.Genre.fetch()
        response.services = await Stream.Service.fetch()
        return response
    }
    
    /// Watchnow endpoint
    /// Build + return Browse sections data
    ///
    public static func recommended (_ request: Request) async throws -> Response {
        do {
            var response = Response()
            if let query: Neo4jService.Query = try await Self.getClaims(request: request) {
                response.streams = await Stream.recommended(query: query)
            } else {
                request.logger.error(.init(stringLiteral: .claimsDeocodingError))
            }
            return response
        } catch let error {
            // Return error
            request.logger.error(.init(stringLiteral: error.localizedDescription))
            return Response(error: error.localizedDescription)
        }
    }
 
    /// Browse endpoint
    /// Build + return Browse sections data
    ///
    public static func browse (_ request: Request) async throws -> Response {
        do {
            var response = Response()
            if let query: Neo4jService.Query = try await Self.getClaims(request: request) {
                response.streams = await Stream.browse(query: query)
            } else {
                request.logger.error(.init(stringLiteral: .claimsDeocodingError))
            }
            return response
        } catch let error {
            // Return error
            request.logger.error(.init(stringLiteral: error.localizedDescription))
            return Response(error: error.localizedDescription)
        }
    }
    
    /// Search stream by keyword
    ///
    public static func search (_ request: Request) async throws -> Response {
        do {
            var response = Response()
            if let query: Neo4jService.Query = try await Self.getClaims(request: request) {
                let (persons, streams) = await Stream.search(query: query)
                response.persons = persons
                response.streams = streams
            } else {
                request.logger.error(.init(stringLiteral: .claimsDeocodingError))
            }
            return response
        } catch let error {
            // Return error
            request.logger.error(.init(stringLiteral: error.localizedDescription))
            return Response(error: error.localizedDescription)
        }
    }
    
    /// Cloud function to Update database
    /// Returns 0 for success and 1 for failure
    /// Check logs for more details for either situation
    ///
    /// - Parameters:
    ///   - request: `Request`
    public static func update (_ request: Request) async throws -> Response {
        let _ = await Stream.update()
        let response = Response()
        return response
    }
    
    /// Cloud function to drop database
    /// Returns 0 for success and 1 for failure
    /// Check logs for more details for either situation
    ///
    /// - Parameters:
    ///   - request: `Request`
    public static func clear (_ request: Request) async throws -> Response {
        let _ = await Stream.delete()
        let response = Response()
        return response
    }
    
    /// set Relationship
    ///
    /// - Parameters:
    ///   - request: `Request`
    public static func setRelationship (_ request: Request) async throws -> Response {
        var response = Response()
        var relationship: User.Relationship? = nil
        var state: Bool? = nil
        let claims: Stream.Claims? = try await Self.getClaims(request: request)
        
        if let liked = claims?.liked {
            relationship = .LIKED
            state = liked
        } else if let bookmarked = claims?.bookmarked {
            relationship = .BOOKMARKED
            state = bookmarked
        } else if let watched = claims?.watched {
            relationship = .WATCHED
            state = watched
        }
        
        if let id = claims?.id, let user = claims?.user, let state = state, let relationship = relationship {
            let stream = await Stream.setRelationship(relationship: relationship, id: id, user: user, state: state)
            response.stream = stream
        } else {
            response.error = .claimsDeocodingError
            request.logger.error(.init(stringLiteral: .claimsDeocodingError))
        }
        
        return response
    }
    
    /// set Relationship
    ///
    /// - Parameters:
    ///   - request: `Request`
    public static func getRelationship (_ request: Request) async throws -> Response {
        var response = Response()
        var relationship: User.Relationship? = nil
        let claims: Stream.Claims? = try await Self.getClaims(request: request)
        
        if let _ = claims?.likedList {
            relationship = .LIKED
        } else if let _ = claims?.bookmarkedList {
            relationship = .BOOKMARKED
        } else if let _ = claims?.watchedList {
            relationship = .WATCHED
        }
        
        if let user = claims?.user, let relationship = relationship {
            let streams = await Stream.getRelationship(relationship: relationship, user: user)
            response.streams = streams
        } else {
            response.error = .claimsDeocodingError
            request.logger.error(.init(stringLiteral: .claimsDeocodingError))
        }
            
        return response
    }
 }
