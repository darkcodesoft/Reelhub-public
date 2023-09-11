//
//  URLSession.swift
//  Reelhub
//
//  Created by Teddy Moussignac on 8/12/22.
//

import Foundation

/// Defines the possible errors
public enum URLSessionAsyncErrors: Error {
    case invalidUrlResponse, missingResponseData
}

/// An extension that provides async support for fetching a URL
///
/// Needed because the Linux version of Swift does not support async URLSession yet.
public extension URLSession {

}
