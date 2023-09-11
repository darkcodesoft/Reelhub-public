//
//  ReelhubApp.swift
//  Reelhub
//
//  Created by Teddy Moussignac on 5/31/23.
//

import SwiftUI
import Firebase

@main
struct ReelhubApp: App {
    @StateObject private var storeKitStore = StoreKitStore.shared
    @StateObject private var userStore = UserStore.shared
    @StateObject private var streamStore = StreamStore.shared
    @StateObject private var homeStore = HomeStore.shared
    @StateObject private var browseStore = BrowseStore.shared
    @StateObject private var finderStore = FinderStore.shared
    
    init () {
        // Configure Firebase
        FirebaseApp.configure()
    }

    var body: some Scene {
        WindowGroup {
            GeometryReader { geometry in
                ContentView()
                    .environmentObject(storeKitStore)
                    .environmentObject(userStore)
                    .environmentObject(streamStore)
                    .environmentObject(homeStore)
                    .environmentObject(browseStore)
                    .environmentObject(finderStore)
                    .environment(\.screenSize, EnvironmentValues.ScreenSize(width: geometry.size.width, height: geometry.size.height))
                    .onAppear {
                        // Disable constraints warnings.
                        UserDefaults.standard.setValue(false, forKey: "_UIConstraintBasedLayoutLogUnsatisfiable")
                    }
                    .sheet(isPresented: $userStore.showLoginView) {
                        LoginView()
                            .accentColor(.appAccent)
                            .environmentObject(storeKitStore)
                            .environmentObject(userStore)
                    }
            }
        }
    }
}
