//
//  User.swift
//  BudgetBuild
//
//  Created by Bryce Nicholson on 6/30/24.
//
import FirebaseAuth
import FirebaseFirestore
import Foundation


struct User: Codable {
    var id: String = ""
    var name: String = ""
    var email: String = ""
    var joined: TimeInterval = 1
}


