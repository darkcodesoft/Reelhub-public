//
//  AccountView.swift
//  Reelhub
//
//  Created by Teddy Moussignac on 3/30/23.
//

import SwiftUI

final class AccountStore: ObservableObject {
    
}

struct AccountView: View {
    @EnvironmentObject var userStore: UserStore
    @State private var showingAlert = false
    
    var body: some View {
        List {
            if let user = userStore.user {
                // Username
                Section(String.email) {
                    Text(user.email)
                }
            }
            
            // Delete account button
            Section(
                header: Text(String.deleteAccount),
                footer: Text(String.deleteMessage)
            ) {
                Button(String.deleteAccount) {
                    delete()
                }
            }
        }
        .listStyle(.insetGrouped)
        .navigationTitle(String.editAccount)
        .navigationBarTitleDisplayMode(.inline)
    }
    
    // delete account
    func delete () {
        Task {
            userStore.deletingUser = true
            userStore.showLoginView = true
        }
    }
}

struct AccountView_Previews: PreviewProvider {
    static var previews: some View {
        AccountView()
    }
}
