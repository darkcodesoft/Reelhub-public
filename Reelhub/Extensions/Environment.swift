//
//  Environment.swift
//  Reelhub
//
//  Created by Teddy Moussignac on 1/12/22.
//

import Foundation
import SwiftUI

/// List of the app custom environment variables and constants.
struct ScreenSizeKey: EnvironmentKey {
    static let defaultValue: EnvironmentValues.ScreenSize = EnvironmentValues.ScreenSize()
}

/// Add custom constants and variables to environment.
extension EnvironmentValues {

    struct ScreenSize {
        var width: CGFloat = 0
        var height: CGFloat = 0
    }

    var screenSize: ScreenSize {
        get { self[ScreenSizeKey.self] }
        set { self[ScreenSizeKey.self] = newValue }
    }
}
