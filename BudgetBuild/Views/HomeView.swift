//
//  HomeView.swift
//  BudgetBuild
//
//  Created by Bryce Nicholson on 7/10/24.
//
import FirebaseAuth
import SwiftUI

struct HomeView: View {
    
    private let userId: String
    
    init(userId: String){
        self.userId = userId
    }
    
    var body: some View {
        NavigationStack{
            VStack{
                Text(Auth.auth().currentUser?.uid ?? "").foregroundStyle(Color.purple)
                Spacer()
            }
        }
        
        
    }
        

}

//#Preview {
//    HomeView()
//}
