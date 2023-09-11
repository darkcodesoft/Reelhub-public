//
//  Provider.swift
//  Reelhub
//
//  Created by Teddy Moussignac on 12/28/21.
//

import Foundation
import SwiftUI

extension Stream.Service {
    /// Provider list
    enum Provider: String, Codable, Hashable, CaseIterable, Identifiable {
        case apple
        case disney
        case hbo
        case hulu
        case max
        case mubi
        case netflix
        case paramount
        case peacock
        case prime
        case showtime
        case starz

        var id: String { self.rawValue }

        /// Get provider constant from service name
        ///
        /// - Parameters:
        ///   - name: Service name
        static func name (_ name: String) -> String {
            switch Self(rawValue: name) {
            case .apple:
                return .apple
            case .disney:
                return .disney
            case .hbo:
                // HBO Max to MAX prep.
                // May 23rd
                let now = Date.now
                let formatter = DateFormatter()
                formatter.dateStyle = .short
                formatter.timeStyle = .short
                let targetDateString = "5/23/23, 12:00 AM"
                if let targetDate = formatter.date(from: targetDateString), now >= targetDate {
                    return .max
                }
                return .hbo
            case .hulu:
                return .hulu
            case .max:
                return .max
            case .mubi:
                return .mubi
            case .netflix:
                return .netflix
            case .paramount:
                return .paramount
            case .peacock:
                return .peacock
            case .prime:
                return .prime
            case .showtime:
                return .showtime
            case .starz:
                return .starz
            case let name:
                return name!.rawValue
            }
        }
    }
}
