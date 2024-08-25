//
//  BudgetBuildApp.swift
//  BudgetBuild
//
//  Created by Bryce Nicholson on 6/21/24.
//
import FirebaseCore
import SwiftUI

@main
struct BudgetBuildApp: App {
    init(){
        FirebaseApp.configure()
    }
    var body: some Scene {
        WindowGroup {
            MainView()
        }
    }
}
