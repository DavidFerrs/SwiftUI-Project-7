//
//  Expense.swift
//  iExpense
//
//  Created by David Ferreira on 05/03/25.
//

import Foundation
import SwiftData

@Model
class ExpenseItem {
    var id = UUID()
    let name: String
    let type: String
    let amount: Double
    
    init(id: UUID = UUID(), name: String, type: String, amount: Double) {
        self.id = id
        self.name = name
        self.type = type
        self.amount = amount
    }
}
