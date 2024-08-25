//
//  BuildViewModel.swift
//  BudgetBuild
//
//  Created by Bryce Nicholson on 7/21/24.
//

import FirebaseAuth
import FirebaseFirestore
import Combine
import Foundation


// Sub-Category View Model
//class SubCategoryViewModel: ObservableObject, Identifiable {
//    var id: String
//    @Published var name: String
//    @Published var amount: Double
//    
//    init(id: String, name: String, amount: Double) {
//        self.id = id
//        self.name = name
//        self.amount = amount
//    }
//    
//    init(budgetItem: budgetItem){
//        self.id = budgetItem.id
//        self.name = budgetItem.name
//        self.amount = budgetItem.amount
//    }
//}
// Category View Model
//class CategoryViewModel: ObservableObject, Identifiable {
//    var id: String
//    @Published var name: String
//    @Published var SubCategoryViewModels: [SubCategoryViewModel]
//    init(id: String, name: String, SubCategoryViewModels: [SubCategoryViewModel]){
//        self.id = id
//        self.name = name
//        self.SubCategoryViewModels = SubCategoryViewModels
//    }
//    
//    init(category: Category) {
//        self.id = category.id
//        self.name = category.name
//        self.SubCategoryViewModels = category.Subcategories.map { (SubCategory) -> SubCategoryViewModel in
//            return SubCategoryViewModel(budgetItem: SubCategory)
//        }
//    }
//}


// Main Budget View Model
class BuildViewModel: ObservableObject {

//    @Published var CategoryViewModels: [CategoryViewModel] = []
    
    
    
//    func addNewCategory(){
//        CategoryViewModels.append(CategoryViewModel(id: UUID().uuidString, name: "", SubCategoryViewModels: []))
//    }
//    
//    func addNewSubCategory(CategoryViewModel: CategoryViewModel){
//        CategoryViewModel.SubCategoryViewModels.append(SubCategoryViewModel(id: UUID().uuidString, name: "", amount: 0.00))
//    }
    
    func save() {
        
        // Check if can save
        guard canSave else {
            return
        }
        
        guard let uId = Auth.auth().currentUser?.uid else {
            return
        }
        
        //Create model
        
//        for CategoryViewModel in CategoryViewModels {
//            var SubCategories: [budgetItem] = []
//            for SubCategory  in CategoryViewModel.SubCategoryViewModels {
//                SubCategories.append(budgetItem(id: SubCategory.id, name: SubCategory.name, amount: SubCategory.amount))
//            }
//            SavedBudget.append(Category(id: CategoryViewModel.id, name: CategoryViewModel.name, Subcategories: SubCategories))
//        }
//        let newId = UUID().uuidString
//        let newItem = Budget(id: newId, current: true ,created: Date().timeIntervalSince1970, Categories: SavedBudget)
//        //Save to database
//        let db = Firestore.firestore()
//        
//        db.collection("users")
//            .document(uId)
//            .collection("budget")
//            .document("123")
//            .setData(newItem.asDictionary())
////        
        return
    }
    
    var canSave: Bool {
        
        return true
    }
    
}

