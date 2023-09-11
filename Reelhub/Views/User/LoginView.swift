//
//  LoginView.swift
//  Reelhub
//
//  Created by Teddy Moussignac on 4/7/23.
//

import SwiftUI
import Firebase

struct LoginView: View {
    @EnvironmentObject var userStore: UserStore
    @EnvironmentObject var storeKitStore: StoreKitStore
    
    // View fetching state
    @State private var fetching = false
    
    // View title based on mode
    var title: String {
        // Login and Register title
        var text = userStore.mode == .Login ? String.login : String.appName
        // Deleting user title
        if userStore.deletingUser {
            text = .deleteAccount
        }
        // Forgot password title
        if userStore.mode == .ForgotPassword {
            text = .resetPassword
        }
        return text
    }
    
    // Submit button label text
    var submitButtonLabel: String {
        // Login and Register title
        var text = userStore.mode == .Login ? String.login : String.register
        // text for mode
        switch userStore.mode {
        case .Login:
            text = .login
        case .Register:
            text = "Subscribe for \(StoreKitStore.shared.subscriptions.first?.displayPrice ?? "")/month"
        case .ForgotPassword:
            text = .sendResetPassword
        }
        // Deleting user title
        if userStore.deletingUser {
            text = .deleteAccount
        }
        // Forgot password title
        return text
    }
    
    // Detects if form is valid
    var formIsValid: Bool {
        (String.isValidEmail(userStore.mode == .Login ? userStore.email : userStore.newEmail) &&
        String.isValidPassword(userStore.mode == .Login ? userStore.password : userStore.newPassword)) ||
        (userStore.mode == .ForgotPassword && String.isValidEmail(userStore.email))
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                // background
                Color(uiColor: .black)
                    .ignoresSafeArea()
                
                // Content
                VStack {
                    // Register message
                    if userStore.mode == .Register && !storeKitStore.subscriptions.isEmpty {
                        VStack {
                            Text("Unlock Full Access")
                                .font(.xlarge)
                                .fontWeight(.bold)
                                .foregroundColor(.appSecondary)
                                .padding()
                            Text("""
                            Remove ads. Unlock saving, bookmarking, and AI-powered search and recommendations for just \(storeKitStore.subscriptions.first?.displayPrice ?? "")/month.
                            """)
                                .font(.medium)
                                .foregroundColor(.white.opacity(0.9))
                                .lineLimit(nil)
                                .multilineTextAlignment(.center)
                                .padding(.bottom, .large)
                        }
                   }
                    
                    // Error stack
                    if userStore.errors.count > 0 || userStore.successes.count > 0 {
                        VStack {
                            ForEach(userStore.errors + userStore.successes, id: \.self) { error in
                                HStack {
                                    // Text
                                    Text(error)
                                        .font(.small)
                                        .lineLimit(nil)
                                        .multilineTextAlignment(.leading)
                                        .padding(.xsmall)
                                        .background(Color.orange)
                                        .cornerRadius(.xsmall)
                                    
                                    // Trailing spacing
                                    Spacer()
                                }
                                .foregroundColor(.black)
                                .padding(.bottom, .small)
                            }
                        }
                        .padding(.bottom, .small)
                    }
                    
                    // Email field
                    TextField(String.email, text: (userStore.mode == .Login || userStore.mode == .ForgotPassword) ? $userStore.email : $userStore.newEmail)
                        .font(.large)
                        .textFieldStyle(.roundedBorder)
                        .autocorrectionDisabled(true)
                        .autocapitalization(.none)
                        .textContentType(.emailAddress)
                    
                    if userStore.mode == .Login {
                        // Login password secure field
                        SecureField(String.password, text: userStore.mode == .Login ? $userStore.password : $userStore.newPassword)
                            .font(.large)
                            .textFieldStyle(.roundedBorder)
                            .autocorrectionDisabled(true)
                            .autocapitalization(.none)
                            .textContentType(userStore.mode == .Register ? .newPassword : .password)
                    } else if userStore.mode == .Register {
                        if userStore.showPassword == true {
                            // New password unmasked field
                            TextField(String.password, text: userStore.mode == .Login ? $userStore.password : $userStore.newPassword)
                                .font(.large)
                                .textFieldStyle(.roundedBorder)
                                .autocorrectionDisabled(true)
                                .autocapitalization(.none)
                        } else {
                            // New password secure field
                            SecureField(String.password, text: userStore.mode == .Login ? $userStore.password : $userStore.newPassword)
                                .font(.large)
                                .textFieldStyle(.roundedBorder)
                                .autocorrectionDisabled(true)
                                .autocapitalization(.none)
                                .textContentType(userStore.mode == .Register ? .newPassword : .password)
                        }
                        
                        // Show password toggler
                        Toggle(isOn: $userStore.showPassword) {
                            Text(String.showPassword)
                                .font(.small)
                                .frame(maxWidth: .infinity, alignment: .trailing)
                        }
                    }
                    
                    // Submit button
                    Button(action: {
                        submitForm()
                    }, label: {
                        HStack {
                            Spacer()
                            if fetching == true {
                                ProgressView()
                                    .accentColor(.black)
                            } else {
                                Text(submitButtonLabel)
                                    .fontWeight(.bold)
                                    .padding(.medium)
                            }
                            Spacer()
                        }
                    })
                    .frame(maxWidth: .infinity)
                    .frame(height: 42)
                    .background(Color.appAccent)
                    .foregroundColor(.black)
                    .cornerRadius(.small)
                    .padding(.top, .small)
                    
                    // Message
                    if userStore.deletingUser == true {
                        // If deleting account
                        Text(String.deleteMessage)
                            .font(.small)
                            .foregroundColor(.appPrimary.opacity(0.5))
                            .multilineTextAlignment(TextAlignment.center)
                            .padding(.top)
                    } else {
                        // Log/Register Toggle
                        Button(action: {
                            if userStore.mode == .Register || userStore.mode == .ForgotPassword {
                                userStore.mode = .Login
                            } else {
                                userStore.mode = .Register
                            }
                        }, label: {
                            if userStore.mode == .Register {
                                Text(String.loginMessage)
                            } else if userStore.mode == .ForgotPassword {
                                Text(String.goBackToLogin)
                            } else {
                                Text(String.registerMessage)
                            }
                        })
                        .font(.small)
                        .padding(.top, .large)
                        
                        // Forgot password.
                        Button(action: {
                            userStore.mode = .ForgotPassword
                        }, label: {
                            Text(String.forgotPassword)
                        })
                        .font(.small)
                        .padding(.top, .medium)
                        .opacity(userStore.mode != .ForgotPassword ? 1 : 0)
                    }
                }
                .padding()
                .padding()
                .navigationTitle(title)
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button(action: {
                            userStore.showLoginView.toggle()
                        }, label: {
                            Text(String.cancel)
                        })
                    }
                }
                .task {
                    // reset error & success stacks on load
                    userStore.errors.removeAll()
                    userStore.successes.removeAll()
                    
                    // Set mode
                    if userStore.deletingUser == true {
                        userStore.mode = .Login
                    } else {
                        userStore.mode = .Register
                    }
                }
                .onDisappear {
                    // reset form to default
                    userStore.deletingUser = false
                    resetForm()
                }
            }
        }
    }
    
    //
    func resetForm () {
        userStore.email = ""
        userStore.newEmail = ""
        userStore.password = ""
        userStore.newPassword = ""
    }
    
    func submitForm () {
        // validate form.
        guard formIsValid == true && fetching == false else {
            userStore.throwError(userStore.mode == .ForgotPassword ? .emailError : .loginError)
            return
        }
        
        // perform action.
        Task {
            fetching = true
            // reset error stack on form submit
            userStore.errors.removeAll()
            
            // user store mode action dispatcher
            switch userStore.mode {
            case .Login:
                let _ = await userStore.login()
            case .Register:
                let _ = await userStore.register()
            case .ForgotPassword:
                let _ = await userStore.forgotPassword()
            }
            
            fetching = false
            
            // Dismiss form.
            if userStore.isLoggedIn && userStore.errors.count == 0 {
                userStore.showLoginView.toggle()
            }
        }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        @State var storeKitStore = StoreKitStore.shared
        @State var userStore = UserStore.shared
        LoginView()
            .environmentObject(storeKitStore)
            .environmentObject(userStore)
    }
}
