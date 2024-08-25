//
//  LoginView.swift
//  BudgetBuild
//
//  Created by Bryce Nicholson on 6/28/24.
//

import SwiftUI

struct LoginView: View {
    @StateObject var loginModel = LoginViewModel()
    var body: some View {
        
        NavigationStack{
            VStack{
                Spacer(minLength: 200)
                Form{
                    if !loginModel.errorMessage.isEmpty {
                        Text(loginModel.errorMessage)
                            .foregroundStyle(.red)
                    }
                    TextField("Email", text: $loginModel.email)
                        .textFieldStyle(.plain)
                        .textInputAutocapitalization(.none)
                    SecureField("Password", text: $loginModel.password)
                        .textFieldStyle(.plain)
                        .textInputAutocapitalization(.none)
                    Button{
                        loginModel.login()
                    } label: {
                        ZStack{
                            RoundedRectangle(cornerRadius: 10)
                                .foregroundStyle(.green)
                            Text("Login")
                                .foregroundStyle(.white)
                                .bold()
                        }
                    }
                    .padding(.top, 10)
                    .padding(.bottom, 10)
                }.scrollContentBackground(.hidden)
                
                
                // Register Screen
                VStack{
                    Text("Don't have an account?")
                        .frame(width: UIScreen.main.bounds.width)
                        .padding(.top, 5)
                    NavigationLink("Create an account", destination: RegisterView())
                }
                .background(.white)
                
                   

            }.background(Color(red: 0.9, green: 0.9, blue: 0.9))
            
        }
    }
}

#Preview {
    LoginView()
}
