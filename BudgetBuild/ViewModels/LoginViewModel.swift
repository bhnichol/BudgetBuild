//
//  LoginViewModel.swift
//  BudgetBuild
//
//  Created by Bryce Nicholson on 6/29/24.
//

import FirebaseAuth
import Foundation

class LoginViewModel: ObservableObject {
    @Published var email = ""
    @Published var password = ""
    @Published var errorMessage = ""
    
    init() {}
    
    func login() {
        guard validate()else{
            return
        }

        Auth.auth().signIn(withEmail: email, password: password){(auth, error) in
            if let x = error {
                let err = x as NSError
                switch err.code {
                case AuthErrorCode.wrongPassword.rawValue:
                    self.errorMessage = "Incorrect password"
                case AuthErrorCode.invalidEmail.rawValue:
                    self.errorMessage = "Incorrect email"
                case AuthErrorCode.invalidCredential.rawValue:
                    self.errorMessage = "Incorrect email or password"
                default:
                    self.errorMessage = err.localizedDescription
                }
            }
        }
        
        
    }
    
    private func validate() -> Bool {
        errorMessage = ""
        guard !email.trimmingCharacters(in: .whitespaces).isEmpty,
              !password.trimmingCharacters(in: .whitespaces).isEmpty else {
            errorMessage = "Please fill in all fields"
            return false
        }
        guard email.contains("@") && email.contains(".") else {
            errorMessage = "Please enter valid email"
            return false
        }
        return true
    }
}
