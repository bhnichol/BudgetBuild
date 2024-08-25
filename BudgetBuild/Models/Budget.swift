//
//  Budget.swift
//  BudgetBuild
//
//  Created by Bryce Nicholson on 7/16/24.
//

import Foundation

struct Budget: Identifiable, Codable {
    let id: String
    let current: Bool
    let created: TimeInterval
    let Categories: [Category]
}

struct Category: Identifiable, Codable {
    let id: String
    let name: String
    let Subcategories: [budgetItem]
    let color: [String: Double]
    let icon: String
    let created: TimeInterval
}

struct budgetItem: Identifiable, Codable {
    var id: String
    var name: String
    var amount: Double
    var catID: String

}
