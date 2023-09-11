//
//  UserController.swift
//  
//
//  Created by Teddy Moussignac on 11/5/21.
//

import Foundation
import Vapor

final class UserController: Controller {
    ///
    /// - Parameters:
    ///   - request: `Request`
    public static func set (_ request: Request) async throws -> Response {
        do {
            var response = Response()
            if let claims: User.Claims = try await Self.getClaims(request: request) {
                let user = User(claims: claims)
                let node = await User.set(user)
                response.user = node
                response.claims = claims
            }
            return response
        } catch let error {
            return Response(error: error.localizedDescription)
        }
    }
    
    ///
    /// - Parameters:
    ///   - request: `Request`
    public static func delete (_ request: Request) async throws -> Response {
        do {
            var response = Response()
            // Get JWT Token from post request
            if let claims: User.Claims = try await Self.getClaims(request: request) {
                let user = User(claims: claims)
                let _ = await User.delete(user)
                response.user = nil
                response.claims = claims
            }
            return response
        } catch {
            return Response(error: error.localizedDescription)
        }
    }
}
