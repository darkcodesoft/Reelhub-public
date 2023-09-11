//
//  Cloud.swift
//  Reelhub
//
//  Created by Teddy Moussignac on 12/26/21.
//

import Foundation
import Alamofire
import CryptoKit

class Cloud {
    static private let host = "https://reelhub.app/"
    static private let version = 1
    static private var api: String { "\(Self.host)api/v\(Self.version)/" }
    
    // Get cloud key
    static var key: Data {
        let keyUrl: URL? = Bundle.main.url(forResource: "budderR256.key.pub", withExtension: nil)
        let key = try! Data(contentsOf: keyUrl!)
        return key
    }
    
    /// Endpoint Enum
    enum Endpoint: String {
        case stream
        case recommended
        case browse
        case search
        case settings
        case privacy
        case terms
        case user
        case liked
        case likedList = "liked-list"
        case bookmarked
        case bookmarkedList = "bookmarked-list"
        case watched
        case watchedList = "watched-list"
        
        // Returns full api endpoint url.
        var path: String {
            switch self {
            case .privacy:
                return Cloud.host + "privacy-policy/"
            case .terms:
                return Cloud.host + "terms-of-use/"
            case .liked, .likedList, .bookmarked, .bookmarkedList, .watched, .watchedList:
                return Cloud.api + "stream/" + self.rawValue + "/"
            default:
                return Cloud.api + self.rawValue + "/"
            }
        }
    }
    
    /// Cloud request
    ///
    /// - Parameters:
    ///   - endpoint: The api endpoint
    ///   - query: The request query parameters
    ///   - method: The request http method
    static func request<T: Codable> (_ endpoint: Endpoint,
                                    query: Dictionary<String, Codable> = [:],
                                    method: HTTPMethod = .get,
                                    headers: HTTPHeaders? = nil,
                                    claims: Codable? = nil,
                                    log: Bool = false) async throws -> T {
        var requestHeaders: HTTPHeaders = headers ?? []
        
        // Tokenize claims
        if let claims = claims {
            let token = Cloud.encodeJWT(claims: claims)
            let bearerToken: HTTPHeader = .authorization(bearerToken: token)
            requestHeaders.add(bearerToken)
        }
        
        return try await withCheckedThrowingContinuation { (continuation: CheckedContinuation<T, Error>) in
            let url = endpoint.path
            let utilityQueue = DispatchQueue.global(qos: .utility)
            AF.request(url, method: method, parameters: query as Parameters, headers: requestHeaders)
                .responseDecodable(of: T.self, queue: utilityQueue) { response in
                    switch response.result {
                    case let .success(success):
                        if log == true {
                            print(success)
                        }
                        continuation.resume(returning: success)
                    case let .failure(error):
                        if log == true {
                            print(error)
                        }
                        continuation.resume(throwing: error)
                    }
                }.cURLDescription { description in
                    print(description)
                }
        }
    }
     
    /// Cloud request
    ///
    /// - Parameters:
    ///   - endpoint: The api endpoint
    ///   - query: The request query parameters
    ///   - method: The request http method
    func request<T: Codable> (_ endpoint: Endpoint,
                              query: Dictionary<String, Codable> = [:],
                              method: HTTPMethod = .get,
                              headers: HTTPHeaders? = nil,
                              claims: Codable? = nil) async throws -> T {
        return try await Self.request(endpoint, query: query, method: method, headers: headers, claims: claims)
    }
}

extension Cloud {
    ///
    struct Query: Codable, Hashable {
        var id: Int?
        var page = 1
        var type: String?
        var genres: [Int]?
        var section: String?
        var weight: Int?
        var services: [String]?
        var person: String?
        var filmakers: [Stream.Person]?
        var cast: [Stream.Person]?
        var order: String?
        var limit = Cloud.Response.limit
        var keyword: String? = nil
        var uid: String?
        var likes: Bool?
        var bookmarks: Bool?
    }
    
    ///
    struct Response: Codable {
        var streams: [Stream]?
        var stream: Stream?
        var services: [Stream.Service]?
        var genres: [Stream.Genre]?
        var persons: [Stream.Person]?
        var query: Cloud.Query?
        var users: [User]?
        var user: User?
        var error: String?
        
        // response items per page
        static let limit = 25
    }
    
    /// JWTHeader definition
    struct JWTHeader: Codable {
        var alg = "HS256"
        var typ = "JWT"
    }
    
    ///
    ///
    /// Encode JWT token
    ///
    /// - Parameters:
    /// - claims: Claims
    static func encodeJWT (claims: Codable) -> String {
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
    static func deocodeJWT<T:Decodable>(token: String) -> T? {
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
}
