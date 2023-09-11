//
//  MoreMenuView.swift
//  Reelhub
//
//  Created by Teddy Moussignac on 1/12/22.
//

import SwiftUI
import MessageUI

struct MoreMenuView: View {
    @EnvironmentObject var userStore: UserStore
    
    @State private var accountLinkIsActive = false
    @State private var navigationLinkIsActive = false
    @State private var webViewLinkIsActive = false
    @State private var relationshipStore: RelationshipStore? = nil
    @State private var webViewStore: WebViewStore? = nil
    @State private var accountStore: AccountStore? = nil
    @State private var result: Result<MFMailComposeResult, Error>? = nil
    @State private var isShowingMailView = false
    
    // Account menu section
    private let accountMenu = Menu.Section(items: [
        Menu.Item(
            label: .editAccount,
            icon: "person.fill",
            destinationViewName: .Account
        )
    ])
     
    // Build relationships menu section
    private var relationshipMenu: Menu.Section {
        var section = Menu.Section()
        for relationship in User.Relationship.allCases {
            var menu = Menu.Item(
                label: relationship.rawValue.capitalized,
                relationship: relationship
            )
            
            switch relationship {
            case .LIKED:
                menu.icon = "heart.fill"
            case .BOOKMARKED:
                menu.icon = "bookmark.fill"
            case .WATCHED:
                menu.icon = "checkmark.circle.fill"
            }
            section.items.append(menu)
        }
        return section
    }
    
    // Policy Menu section
    private let policyMenu = Menu.Section(items: [
        Menu.Item(
            label: .help,
            destinationViewName: .Help
        ),
        Menu.Item(
            label: .privacyPolicy,
            url: Cloud.Endpoint.privacy.path
        ),
        Menu.Item(
            label: .terms,
            url: Cloud.Endpoint.terms.path
        )
    ])
    
    var body: some View {
        NavigationView {
            ZStack {
                // MARK: Logged In
                // Shared NavigationLink.
                NavigationLink(
                    destination: RelationshipView().environmentObject(relationshipStore ?? .init()),
                    isActive: $navigationLinkIsActive
                ) { EmptyView().frame(width: 0, height: 0) }
                
                // WebView NavigationLink.
                NavigationLink(
                    destination: WebView().environmentObject(webViewStore ?? .init()),
                    isActive: $webViewLinkIsActive
                ) { EmptyView().frame(width: 0, height: 0) }
                
                // Acount NavigationLink.
                NavigationLink(
                    destination: AccountView().environmentObject(accountStore ?? .init()),
                    isActive: $accountLinkIsActive
                ) { EmptyView().frame(width: 0, height: 0) }
                
                List {
                    if let _ = UserStore.shared.user {
                        // Likes + Bookmarks
                        Section {
                            ForEach(relationshipMenu.items) { item in
                                Button(action: {
                                    navigateTo(menuItem: item)
                                }, label: {
                                    HStack {
                                        Image(systemName: (item.icon ?? ""))
                                            .resizable()
                                            .frame(width: 16, height: 16)
                                            .foregroundColor(Color.gray.opacity(0.7))
                                            .padding(.trailing, .small)
                                        Text(item.label ?? "")
                                           .foregroundColor(.appPrimary)
 
                                        Spacer()
                                        Image(systemName: "chevron.right")
                                            .foregroundColor(.gray)
                                    }
                                })
                            }
                        }
                        
                        // Acount actions
                        Section {
                            ForEach(accountMenu.items) { item in
                                Button(action: {
                                    navigateTo(menuItem: item)
                                }, label: {
                                    HStack {
                                        Image(systemName: (item.icon ?? ""))
                                            .resizable()
                                            .frame(width: 16, height: 16)
                                            .foregroundColor(Color.gray.opacity(0.7))
                                            .padding(.trailing, .small)
                                        Text(item.label ?? "")
                                           .foregroundColor(.appPrimary)
 
                                        Spacer()
                                        Image(systemName: "chevron.right")
                                            .foregroundColor(.gray)
                                    }
                                })
                            }
                        }
                        
                    }
                        
                    // Privacy
                    Section {
                        ForEach(policyMenu.items) { item in
                            Button(action: {
                                navigateTo(menuItem: item)
                            }, label: {
                                HStack {
                                    Text(item.label ?? "")
                                       .foregroundColor(.appPrimary)
                                    
                                    Spacer()
                                    Image(systemName: "chevron.right")
                                        .foregroundColor(.gray)
                                }
                            })
                        }
                    }
                    
                    // Login button
                    if !userStore.isLoggedIn {
                        Button(action: { userStore.showLoginView.toggle() }, label: {Text("Log in for more menu options.")})
                    }
                }
                
            }
            .listStyle(.insetGrouped)
            .navigationTitle(String.account)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        if !userStore.isLoggedIn {
                            userStore.showLoginView.toggle()
                        } else {
                            Task {
                                await userStore.logout()
                            }
                        }
                    }, label: {
                        Text(userStore.isLoggedIn ? String.logout : String.loginLabel)
                    })
                }
            }
            .sheet(isPresented: $isShowingMailView) {
                MailView(isShowing: self.$isShowingMailView, result: self.$result)
            }
        }
    }
    
    /// Set current `StreamDetailedStore`.
    ///
    /// - Parameters:
    ///   - stream: stream item
    func navigateTo (menuItem: Menu.Item) {
        Task.init {
            // navigate to collection
            if let relationship = menuItem.relationship {
                relationshipStore = .init(relationship)
                navigationLinkIsActive = true
            }
            
            if let url = menuItem.url, url.count > 0 {
                webViewStore = .init(url: menuItem.url)
                webViewStore?.title = menuItem.label ?? ""
                webViewLinkIsActive = true
            }
            
            if let destinationViewName = menuItem.destinationViewName, destinationViewName == .Help {
                self.isShowingMailView.toggle()
            }
            
            if let destinationViewName = menuItem.destinationViewName, destinationViewName == .Account {
                accountStore = .init()
                accountLinkIsActive = true
            }
        }
    }
}

struct MoreMenuView_Previews: PreviewProvider {
    static var previews: some View {
        let user = UserStore()
        MoreMenuView()
            .environmentObject(user)
            .colorScheme(.dark)
    }
}
