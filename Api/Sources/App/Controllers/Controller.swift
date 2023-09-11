//
//  Controller.swift
//  
//
//  Created by Teddy Moussignac on 1/18/23.
//

import Foundation
import Vapor

class Controller {
    /// Server response definition.
    struct Response: Content, Codable {
        var streams: [Stream]?
        var stream: Stream?
        var services: [Stream.Service]?
        var genres: [Stream.Genre]?
        var persons: [Stream.Person]?
        var filmakers: [Stream.Person]?
        var cast: [Stream.Person]?
        var query: Neo4jService.Query?
        var users: [User]?
        var user: User?
        var claims: User.Claims?
        var error: String?
    }
    
    /// JWTHeader definition
    struct JWTHeader: Codable, Hashable {
        var alg = "HS256"
        var typ = "JWT"
    }

    /// Get request public key
    static private func publicKey (request: Request) async throws -> Data? {
        let buffer = try await request.fileio.collectFile(at: "budderR256.key.pub")
        let string = String(buffer: buffer)
        let data = Data(string.utf8)
        return data
    }
    
    /// Get request private key
    static private func privateKey (request: Request) async throws -> Data? {
        let buffer = try await request.fileio.collectFile(at: "budderR256.key")
        let string = String(buffer: buffer)
        let data = Data(string.utf8)
        return data
    }
    
    ///
    /// Encode JWT token
    ///
    /// - Parameters:
    /// - claims: Claims
    static private func encodeJWT (claims: Codable, key: Data) -> String {
        // header
        let header = JWTHeader()
        let headerJSONData = try! JSONEncoder().encode(header)
        let headerBase64String = headerJSONData.base64EncodedString()
        // claims
        let claimsJSONData = try! JSONEncoder().encode(claims)
        let claimsBase64String = claimsJSONData.urlSafeBase64EncodedString()
        // signature
        let payload = Data((headerBase64String + "." + claimsBase64String).utf8)
        let symmetricKey = SymmetricKey(data: Data(key))
        let signature = HMAC<SHA256>.authenticationCode(for: payload, using: symmetricKey)
        let signatureBase64String = Data(signature).urlSafeBase64EncodedString()
        // token
        let jwt = headerBase64String + "." + claimsBase64String + "." + signatureBase64String
        let data = Data(jwt.utf8)
        // encoded token
        return data.urlSafeBase64EncodedString()
    }
    
    ///
    /// Decode JWT
    ///
    /// - Parameters:
    /// - token: String
    static private func deocodeJWT<T:Decodable>(token: String) -> T? {
        // get token data
        guard let data = String.base64UrlDecode(token) else {
            return nil
        }
        // get token string from data
        let jwt = String(data: data, encoding: .utf8) ?? ""
        let segments = jwt.components(separatedBy: ".")
        // Claims
        let claims = segments[1]
        guard let claimsData = String.base64UrlDecode(claims) else {
            return nil
        }
        // return
        let decoder = JSONDecoder()
        let result = try! decoder.decode(T.self, from: claimsData)
        return result
    }
     
    ///
    /// Get Request claims from token.
    ///
    /// - Parameters:
    /// - request: Request
    static func getClaims <T:Codable>(request: Request) async throws -> T? {
        if let token = request.headers.bearerAuthorization?.token, let key = try await publicKey(request: request) {
            request.logger.info(.init(stringLiteral:"verify token: \(token)"))
            let claims: T? = deocodeJWT(token: token)
            let verifier = encodeJWT(claims: claims, key: key)
            // verify then return
            request.logger.info(.init(stringLiteral: "verified: \(token == verifier)"))
            // return token == verifier ? claims : nil
            return claims // TODO
        }
        return nil
    }
}
