import Vapor

func routes(_ app: Application) throws {
    // site pages
    app.get("", use: HomeController.index)
    app.get("privacy-policy", use: HomeController.privacy)
    app.get("terms-of-use", use: HomeController.terms)
    app.get("contact-us", use: HomeController.contact)

    // api v1 endpoint
    let api = app.grouped("api", "v1")
    // root endpoints
    api.get("recommended", use: StreamController.recommended)
    api.get("browse", use: StreamController.browse)
    api.get("settings", use: StreamController.settings)
    api.get("search", use: StreamController.search)
    
    // user endpoint
    api.group("user") { user in
        user.post("", use: UserController.set)
        user.delete("", use: UserController.delete)
    }

   // streaming endpoint
    api.group("stream") { stream in
        stream.get("", use: StreamController.index)
        stream.post("liked", use: StreamController.setRelationship)
        stream.post("liked-list", use: StreamController.getRelationship)
        stream.post("bookmarked", use: StreamController.setRelationship)
        stream.post("bookmarked-list", use: StreamController.getRelationship)
        stream.post("watched", use: StreamController.setRelationship)
        stream.post("watched-list", use: StreamController.getRelationship)
        stream.post("update", use: StreamController.update)
    }
}
