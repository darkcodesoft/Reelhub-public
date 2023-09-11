//
//  ContentView.swift
//  Reelhub
//
//  Created by Teddy Moussignac on 12/8/21.
//

import SwiftUI
import AuthenticationServices

struct ContentView: View {
    /// Tab items enum
    enum Tab {
        case home
        case browse
        case finder
        case more
    }
    
    /// Default selected tab
    @State private var selection: Tab = .home

    var body: some View {
        TabView(selection: $selection) {
            HomeView()
                .tabItem {
                    Label(String.home, systemImage: "play.fill")
                }
                .tag(Tab.home)

            BrowseView()
                .tabItem {
                    Label(String.browse, systemImage: "square.grid.2x2")
                }
                .tag(Tab.browse)

            FinderView()
                .tabItem {
                    Label(String.finder, systemImage: "magnifyingglass")
                }
                .tag(Tab.finder)

            MoreMenuView()
                .tabItem {
                    Label(String.account, systemImage: "person.fill")
                }
                .tag(Tab.more)
        }
        .colorScheme(.dark)
        .tint(.appAccent)
        .onAppear(perform: {
            // Tab Bar customization
            let tabBarStandardAppearance = UITabBarAppearance()
            tabBarStandardAppearance.configureWithOpaqueBackground()
            tabBarStandardAppearance.backgroundColor = .black

            let tabBarItemAppearance = UITabBarItemAppearance()
            tabBarItemAppearance.normal.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor(.appPrimary)]
            tabBarItemAppearance.normal.iconColor = UIColor(.appPrimary)
            tabBarStandardAppearance.stackedLayoutAppearance = tabBarItemAppearance
             
            UITabBar.appearance().standardAppearance = tabBarStandardAppearance
            UITabBar.appearance().scrollEdgeAppearance = tabBarStandardAppearance

            // Navigation Bar customization
            UINavigationBar.appearance().tintColor = UIColor(Color.appSecondary)
        })
    }
    
   
 }

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .colorScheme(.dark)
    }
}
