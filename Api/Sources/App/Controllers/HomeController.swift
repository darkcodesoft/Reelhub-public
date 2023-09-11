//
//  HomeController.swift
//  
//
//  Created by Teddy Moussignac on 7/7/23.
//

import Foundation
import Vapor

class HomeController {
    /// Homepage
    public static func index (request: Request) async throws -> View {
        let context =  PageContext(pageTitle: .home)
        return try await request.view.render("home", context)
    }

    /// Privacy policy
    public static func privacy (request: Request) async throws -> View {
        let context =  PageContext(
            pageTitle: .privacyPolicy,
            displayHeader: false)
        return try await request.view.render("privacy", context)
    }

    /// Terms of use
    public static func terms (request: Request) async throws -> View {
        let context =  PageContext(
            pageTitle: .termsOfUse,
            displayHeader: false)
        return try await request.view.render("terms", context)
    }

    /// Contact
    public static func contact (request: Request) async throws -> View {
        let context =  PageContext(
            pageTitle: .contactUs)
        return try await request.view.render("contact", context)
    }
}

extension HomeController {
    struct PageContext: Encodable {
        var author = String.author
        var pageTitle: String
        var currentYear = Calendar.current.dateComponents([.year], from: Date.now).year ?? 0
        var displayHeader = true
        var displayFooter = true
    }
}
