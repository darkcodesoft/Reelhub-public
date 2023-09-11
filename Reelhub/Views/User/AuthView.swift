//
//  AuthView.swift
//  Reelhub
//
//  Created by Teddy Moussignac on 11/1/22.
//

import SwiftUI

struct AuthView: View {
    @EnvironmentObject var userStore: UserStore
    
    var body: some View {
        VStack {
            Button(action: {
                userStore.showLoginView.toggle()
            }, label: {
                HStack {
                    Spacer()
                    Text(String.loginLabel)
                        .fontWeight(.bold)
                        .padding(.medium)
                    Spacer()
                }
            })
            .frame(maxWidth: .infinity)
            .frame(height: 42, alignment: .center)
            .background(Color.appAccent)
            .foregroundColor(.black)
            .cornerRadius(.small)
        }
    }
}

struct AuthView_Previews: PreviewProvider {
    static var previews: some View {
        AuthView()
    } 
}
