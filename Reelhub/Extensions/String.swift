//
//  String.swift
//  Reelhub
//
//  Created by Teddy Moussignac on 1/11/22.
//

import Foundation
import SwiftUI

/// List of the app's custom `String` constants.
extension String {
    static let account = "Account"
    static let all = "All"
    static let apple = "Apple TV+"
    static let appName = "Reelhub"
    static let authMessage = "Login for more."
    static let browse = "Browse"
    static let cancel = "Cancel"
    static let contactEmail = "contact@reelhub.app"
    static let contactUs = "Contact Us"
    static let cast = "Cast"
    static let catalogue = "Catalogue"
    static let deleteAccount = "Delete Account"
    static let deleteMessage = "All data related to this account will be permanently deleted. This action cannot be undone."
    static let directors = "Directors / Creators"
    static let disney = "Disney+"
    static let done = "Done"
    static let editAccount = "Edit Account"
    static let email = "Email"
    static let emailError = "Invalid email."
    static let emailSent = "Reset password email sent. Check your email."
    static let filter = "Filters"
    static let finder = "Finder"
    static let followers = "Followers"
    static let following = "Following"
    static let forgotPassword = "Forgot Password?"
    static let format = "Format"
    static let genreCaptions = "Select genres."
    static let genres = "Tags"
    static let goBackToLogin = "Go back to login."
    static let grid = "Grid"
    static let hbo = "HBO Max"
    static let help = "Help"
    static let helpEmail = "help@reelhub.app"
    static let highestRated = "Highest Rated"
    static let hulu = "Hulu"
    static let home = "Home"
    static let inbox = "Inbox"
    static let login = "Log In"
    static let loginError = "Email and/or password is invalid."
    static let loginLabel = "Log In/Subscribe"
    static let loginMessage = "Already have an account? Log in."
    static let logout = "Log Out"
    static let keyword = "Title, Cast, Crew, and More"
    static let latest = "Latests"
    static let layoutCaption = "Select display layout."
    static let layoutLabel = "Display Layout"
    static let likes = "Likes"
    static let list = "List"
    static let max = "Max"
    static let more = "More"
    static let mostPopular = "Most Popular"
    static let mostRecent = "Most Recent"
    static let movie = "Movie"
    static let movies = "Movies"
    static let mubi = "Mubi"
    static let netflix = "Netflix"
    static let orderCaption = "Select sort algorithm."
    static let orderBy = "Order by"
    static let overview = "Overview"
    static let paramount = "Paramount+"
    static let password = "Password"
    static let peacock = "Peacock"
    static let persons = "Persons"
    static let preferences = "Preferences"
    static let prime = "Prime"
    static let privacyPolicy = "Privacy Policy"
    static let register = "Subscribe"
    static let registerMessage = "Don't have an account yet? Subscribe."
    static let resetPassword = "Reset Password"
    static let results = "Results"
    static let search = "Search"
    static let seeAll = "See All"
    static let sendResetPassword = "Send Reset Password Email"
    static let series = "Series"
    static let services = "Services"
    static let serviceCaption = "Select streaming services."
    static let settings = "Settings"
    static let showPassword = "Show Password"
    static let sort = "Sort by"
    static let showtime = "Showtime"
    static let starz = "Starz"
    static let streaming = "Streaming"
    static let title = "Title"
    static let terms = "Terms of Use"
    static let trailer = "Trailer"
    static let trending = "Trending"
    static let tv = "TV"
    static let typeCaption = "Select movie, series or both."
    static let user = "User"
    
    ///
    static func base64UrlDecode(_ value: String) -> Data? {
        var base64 = value
            .replacingOccurrences(of: "-", with: "+")
            .replacingOccurrences(of: "_", with: "/")
        
        let length = Double(base64.lengthOfBytes(using: String.Encoding.utf8))
        let requiredLength = 4 * ceil(length / 4.0)
        let paddingLength = requiredLength - length
        if paddingLength > 0 {
            let padding = "".padding(toLength: Int(paddingLength), withPad: "=", startingAt: 0)
            base64 = base64 + padding
        }
        
        return Data(base64Encoded: base64, options: .ignoreUnknownCharacters)
    }
     
    ///
    private static let slugSafeCharacters = CharacterSet(charactersIn: "0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz-")
    
    public func convertedToSlug() -> String? {
        if let latin = self.applyingTransform(StringTransform("Any-Latin; Latin-ASCII; Lower;"), reverse: false) {
            let urlComponents = latin.components(separatedBy: String.slugSafeCharacters.inverted)
            let result = urlComponents.filter { $0 != "" }.joined(separator: "-")
            
            if result.count > 0 {
                return result
            }
        }
        
        return nil
    }
    
    /// Is valid email
    public static func isValidEmail(_ email: String) -> Bool {
        // here, `try!` will always succeed because the pattern is valid
        let regex = try! NSRegularExpression(pattern: "^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$", options: .caseInsensitive)
        return regex.firstMatch(in: email, options: [], range: NSRange(location: 0, length: email.count)) != nil
    }
    
    /// Is valid password
    public static func isValidPassword(_ password: String) -> Bool {
        return password.count >= 6
    }
}
