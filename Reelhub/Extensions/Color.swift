//
//  Color.swift
//  Reelhub
//
//  Created by Teddy Moussignac on 1/10/22.
//

import Foundation
import SwiftUI

/// Extends Color
extension Color {
    /// Color.Theme Struct
    struct Theme {
        var foreground: Color
        var primary: Color
        var secondary: Color

        /// Creates a constant theme from a primary, secondary, and foreground `Color` values.
        ///
        /// - Parameters:
        ///   - primary: The amount of red in the color.
        ///   - secondary: The amount of green in the color.
        ///   - foreground: The amount of blue in the color.
        init (_ primary: Color, _ secondary: Color, _ foreground: Color) {
            self.primary = primary
            self.secondary = secondary
            self.foreground = foreground
        }
    }

    /// Base 256
    private static var base256: CGFloat = 256

    /// App base colors
    static let appPrimary: Color = .primary
    static let appSecondary: Color = .pink
    static let appAccent: Color = .appSecondary
    static let appGray: Color = .gray.opacity(0.2)
    static let appImageGray: Color = .gray.opacity(0.1)
    static let appSectionHeader: Color = .gray.opacity(0.4)

    /// Creates a constant color from a base256 red, green, and blue component values.
    ///
    /// - Parameters:
    ///   - red: The amount of red in the color.
    ///   - green: The amount of green in the color.
    ///   - blue: The amount of blue in the color.
    ///   - opacity: An optional degree of opacity, given in the range `0` to
    ///     `1`. A value of `0` means 100% transparency, while a value of `1`.
    init(red: Int, green: Int, blue: Int, opacity: Double = 1) {
        self.init(CGColor(
            red: CGFloat(red) / Self.base256,
            green: CGFloat(green) / Self.base256,
            blue: CGFloat(blue) / Self.base256,
            alpha: CGFloat(opacity)
        ))
    }

    /// Service Theme Color.
    /// - Parameters:
    ///   - name: `Service` name
    static func service (_ name: String) -> Theme {
        let provider = Stream.Service.Provider(rawValue: name)
        return Self.provider(provider!)
    }

    /// Provider Theme Color.
    ///
    /// - Parameters:
    ///   - provider: `Service` provider.
    static func provider (_ provider: Stream.Service.Provider) -> Theme {
        switch provider {
        case .disney:
            let blue = Color(red: 17, green: 60, blue: 207)
            return .init(blue, blue, .white)
        case .hbo:
            var purple = Color(red: 153, green: 30, blue: 235)
            // HBO Max to MAX prep.
            // May 23rd
            let now = Date.now
            let formatter = DateFormatter()
            formatter.dateStyle = .short
            formatter.timeStyle = .short
            let targetDateString = "5/23/23, 12:00 AM"
            if let targetDate = formatter.date(from: targetDateString), now >= targetDate {
                purple = Color(red: 10, green: 43, blue: 222)
            }
            return .init(purple, purple, white)
        case .hulu:
            let green = Color(red: 28, green: 231, blue: 131)
            let gray = Color(red: 4, green: 4, blue: 5)
            return .init(green, green, gray)
        case .netflix:
            let red = Color(red: 216, green: 31, blue: 38)
            return .init(red, red, .black)
        case .max:
            let blue = Color(red: 10, green: 43, blue: 222)
            return .init(blue, blue, white)
        case .paramount:
            let blue = Color(red: 0, green: 100, blue: 255)
            return .init(blue, blue, .white)
        case .prime:
            let sky = Color(red: 5, green: 168, blue: 225)
            let blue = Color(red: 34, green: 47, blue: 62)
            return .init(sky, blue, .white)
        case .showtime:
            let red = Color(red: 220, green: 20, blue: 30)
            return .init(red, red, .white)
        default:
            /// Default
            /// Apple, Mubi, Peacock and Starz
            return .init(.white.opacity(0.8), .black, .black)
        }
    }
}
