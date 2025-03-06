//
//  ContentView.swift
//  iExpense
//
//  Created by David Ferreira on 19/02/25.
//

import SwiftData
import SwiftUI

struct ContentView: View {
    
    @State private var showingSheet = false
    @State private var filterExpense = "Show all"
    @State private var sortOrder = [
        SortDescriptor(\ExpenseItem.name),
        SortDescriptor(\ExpenseItem.amount, order: .reverse)
    ]
    
    var body: some View {
        NavigationStack {
            ExpensesView(sortOrder: sortOrder, filter: filterExpense)
                .navigationTitle("iExpense")
                .toolbar {
                    ToolbarItem(placement: .automatic) {
                        NavigationLink("Add expense") {
                            AddView()
                                .navigationBarBackButtonHidden()
                        }
                    }
                    
                    ToolbarItem(placement: .automatic) {
                        Picker("Filter", selection: $filterExpense) {
                            Text("Show all").tag("Show all")
                            Text("Personal").tag("Personal")
                            Text("Business").tag("Business")
                        }
                    }

                    ToolbarItem(placement: .automatic){
                        Menu("Sort", systemImage: "arrow.up.arrow.down") {
                            Picker("SortOrder", selection: $sortOrder) {
                                Text("Sort by name")
                                    .tag([
                                        SortDescriptor(\ExpenseItem.name),
                                        SortDescriptor(\ExpenseItem.amount, order: .reverse)
                                    ])
                                
                                Text("Sort by amount")
                                    .tag([
                                        SortDescriptor(\ExpenseItem.amount, order: .reverse),
                                        SortDescriptor(\ExpenseItem.name)
                                    ])
                            }
                        }
                    }
                }
        }
    }
}


#Preview {
    
    do {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try ModelContainer(for: ExpenseItem.self, configurations: config)
        let expense = ExpenseItem(name: "Lunch Test", type: "Personal", amount: 5.0)
        
        container.mainContext.insert(expense)
        
        return ContentView()
            .modelContainer(container)
    } catch {
        return Text("Failed to create preview: \(error.localizedDescription)")
    }
}
