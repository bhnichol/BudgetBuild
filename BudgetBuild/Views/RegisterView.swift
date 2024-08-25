//
//  RegisterView.swift
//  BudgetBuild
//
//  Created by Bryce Nicholson on 6/29/24.
//

import SwiftUI

struct RegisterView: View {
    @StateObject var registerModel = RegisterViewModel()
    var body: some View {
        
        NavigationStack{
            VStack{
                Spacer(minLength: 200)
                Form{
                    if !registerModel.errorMessage.isEmpty {
                        Text(registerModel.errorMessage)
                            .foregroundStyle(.red)
                    }
                    TextField("Email", text: $registerModel.email)
                        .textFieldStyle(.plain)
                        .textInputAutocapitalization(.none)
                    TextField("Name", text: $registerModel.name)
                        .textFieldStyle(.plain)
                        .textInputAutocapitalization(.none)
                    SecureField("Password", text: $registerModel.password)
                        .textFieldStyle(.plain)
                        .textInputAutocapitalization(.none)
                    SecureField("Confirm Password", text: $registerModel.confirmPassword)
                        .textFieldStyle(.plain)
                        .textInputAutocapitalization(.none)
                    Button{
                        registerModel.register()
                    } label: {
                        ZStack{
                            RoundedRectangle(cornerRadius: 10)
                                .foregroundStyle(.green)
                            Text("Login")
                                .foregroundStyle(.white)
                                .bold()
                        }
                    }
                }.scrollContentBackground(.hidden)
                
                
                // Register Screen
                VStack{
                    Text("Already have an account?")
                        .frame(width: UIScreen.main.bounds.width)
                        .padding(.top, 5)
                    NavigationLink("Sign in", destination: LoginView())
                }
                .background(.white)
                
                   

            }.background(Color(red: 0.9, green: 0.9, blue: 0.9))
            
        }
    }

}

#Preview {
    RegisterView()
}
