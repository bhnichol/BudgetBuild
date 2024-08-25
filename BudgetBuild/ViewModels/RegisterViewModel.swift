//
//  RegisterViewModel.swift
//  BudgetBuild
//
//  Created by Bryce Nicholson on 6/30/24.
//

import FirebaseAuth
import FirebaseFirestore
import Foundation


class RegisterViewModel: ObservableObject {
    @Published var name = ""
    @Published var email = ""
    @Published var password = ""
    @Published var confirmPassword = ""
    @Published var errorMessage = ""
    
    init() {}
    
    func register() {
        guard validate() else {
            return
        }
        Auth.auth().createUser(withEmail: email, password: password) {[weak self] result, error in
            guard let userId = result?.user.uid else {
                return
            }
            
            self?.insertUserRecord(id: userId)
        }
        
    }
    
    private func insertUserRecord(id: String){
        let catIDs = [UUID().uuidString, UUID().uuidString, UUID().uuidString, UUID().uuidString, UUID().uuidString, UUID().uuidString, UUID().uuidString,]
        let Categories = [
            Category(id: catIDs[0], name: "Food", Subcategories: [budgetItem(id: UUID().uuidString, name: "Breakfast", amount: 0, catID: catIDs[0]), budgetItem(id: UUID().uuidString, name: "Lunch", amount: 0, catID: catIDs[0]),budgetItem(id: UUID().uuidString, name: "Dinner", amount: 0, catID: catIDs[0]), budgetItem(id: UUID().uuidString, name: "Groceries", amount: 0, catID: catIDs[0]), budgetItem(id: UUID().uuidString, name: "Restaurants", amount: 0, catID: catIDs[0])], color: ["red": 185/255, "green": 243/255, "blue": 252/255, "opacity": 1], icon: "fork.knife", created: Date().timeIntervalSince1970),
            Category(id: catIDs[1], name: "Housing", Subcategories: [budgetItem(id: UUID().uuidString, name: "Rent", amount: 0, catID: catIDs[1]), budgetItem(id: UUID().uuidString, name: "Mortgage", amount: 0, catID: catIDs[1]), budgetItem(id: UUID().uuidString, name: "Maintenance", amount: 0, catID: catIDs[1])], color: ["red": 174/255, "green": 226/255, "blue": 255/255, "opacity": 1], icon: "house", created: Date().timeIntervalSince1970),
            Category(id: catIDs[2], name: "Utilities", Subcategories: [budgetItem(id: UUID().uuidString, name: "Electric", amount: 0, catID: catIDs[2]), budgetItem(id: UUID().uuidString, name: "Water", amount: 0, catID: catIDs[2]), budgetItem(id: UUID().uuidString, name: "Gas", amount: 0, catID: catIDs[2]), budgetItem(id: UUID().uuidString, name: "Sewer", amount: 0, catID: catIDs[2]), budgetItem(id: UUID().uuidString, name: "Garbage", amount: 0, catID: catIDs[2])], color: ["red": 147/255, "green": 198/255, "blue": 231/255, "opacity": 1], icon: "bolt.circle", created: Date().timeIntervalSince1970),
            Category(id: catIDs[3], name: "Insurance", Subcategories: [budgetItem(id: UUID().uuidString, name: "Car", amount: 0, catID: catIDs[3]), budgetItem(id: UUID().uuidString, name: "House", amount: 0, catID: catIDs[3]), budgetItem(id: UUID().uuidString, name: "Health", amount: 0, catID: catIDs[3]), budgetItem(id: UUID().uuidString, name: "Dental", amount: 0, catID: catIDs[3]), budgetItem(id: UUID().uuidString, name: "Vision", amount: 0, catID: catIDs[3]), budgetItem(id: UUID().uuidString, name: "Life", amount: 0, catID: catIDs[3])], color: ["red": 168/255, "green": 209/255, "blue": 209/255, "opacity": 1], icon: "newspaper", created: Date().timeIntervalSince1970),
            Category(id: catIDs[4], name: "Subscriptions", Subcategories: [budgetItem(id: UUID().uuidString, name: "Internet", amount: 0, catID: catIDs[4]), budgetItem(id: UUID().uuidString, name: "Phone", amount: 0, catID: catIDs[4]), budgetItem(id: UUID().uuidString, name: "Gym", amount: 0, catID: catIDs[4]), budgetItem(id: UUID().uuidString, name: "TV", amount: 0, catID: catIDs[4]), budgetItem(id: UUID().uuidString, name: "Music", amount: 0, catID: catIDs[4])], color: ["red": 253/255, "green": 138/255, "blue": 138/255, "opacity": 1], icon: "calendar.badge.clock.rtl", created: Date().timeIntervalSince1970),
            Category(id: catIDs[5], name: "Pets", Subcategories: [budgetItem(id: UUID().uuidString, name: "Food", amount: 0, catID: catIDs[5]), budgetItem(id: UUID().uuidString, name: "Toys", amount: 0, catID: catIDs[5]), budgetItem(id: UUID().uuidString, name: "Vet", amount: 0, catID: catIDs[5]), budgetItem(id: UUID().uuidString, name: "Grooming", amount: 0, catID: catIDs[5]), budgetItem(id: UUID().uuidString, name: "Boarding", amount: 0, catID: catIDs[5])], color: ["red": 241/255, "green": 257/255, "blue": 181/255, "opacity": 1], icon: "dog", created: Date().timeIntervalSince1970),
            Category(id: catIDs[6], name: "Charity", Subcategories:[budgetItem(id: UUID().uuidString, name: "Birthdays", amount: 0, catID: catIDs[6]), budgetItem(id: UUID().uuidString, name: "Holidays", amount: 0, catID: catIDs[6]), budgetItem(id: UUID().uuidString, name: "Weddings", amount: 0, catID: catIDs[6]), budgetItem(id: UUID().uuidString, name: "Graduation", amount: 0, catID: catIDs[6]), budgetItem(id: UUID().uuidString, name: "Church", amount: 0, catID: catIDs[6]), budgetItem(id: UUID().uuidString, name: "Donations", amount: 0, catID: catIDs[6])], color: ["red": 254/255, "green": 222/255, "blue": 255/255, "opacity": 1], icon: "heart", created: Date().timeIntervalSince1970)]
        let newUser = User(id: id, name: name, email: email, joined: Date().timeIntervalSince1970)
        let db = Firestore.firestore()
        
        db.collection("users")
            .document(id)
            .setData(newUser.asDictionary())
        let batch = db.batch()
        for category in Categories {
            batch.setData(category.asDictionary(), forDocument: db.collection("users").document(id).collection("Categories").document(category.id))
        }
        
        batch.commit()
    }
    
    private func validate() -> Bool{
        guard !name.trimmingCharacters(in: .whitespaces).isEmpty,
              !email.trimmingCharacters(in: .whitespaces).isEmpty,
              !password.trimmingCharacters(in: .whitespaces).isEmpty else {
            errorMessage = "Whites Spaces Not Allowed"
            return false
        }
        
        guard email.contains("@") && email.contains(".") else {
            errorMessage = "Invalid email"
            return false
        }
        
        guard password.count >= 6 else {
            errorMessage = "Password must be longer than 6 characters"
            return false
        }
        guard password == confirmPassword else {
            errorMessage = "Confirm Password does not match"
            return false
        }
        
        return true
              
    }
    
}
