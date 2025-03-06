//
//  iExpenseApp.swift
//  iExpense
//
//  Created by David Ferreira on 19/02/25.
//

import SwiftData
import SwiftUI

@main
struct iExpenseApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: ExpenseItem.self)
    }
}
