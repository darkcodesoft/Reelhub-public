//
//  AuthButton.swift
//  Reelhub
//
//  Created by Teddy Moussignac on 10/31/22.
//

import SwiftUI
import AuthenticationServices

struct AuthButton: UIViewRepresentable {
    func makeUIView(context: Context) -> ASAuthorizationAppleIDButton {
        return ASAuthorizationAppleIDButton(type: .signIn, style: .whiteOutline)
    }
    
    func updateUIView(_ uiView: ASAuthorizationAppleIDButton, context: Self.Context) {}
}

struct AuthButton_Previews: PreviewProvider {
    static var previews: some View {
        AuthButton()
    }
}
