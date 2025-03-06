//
//  ExpensesView.swift
//  iExpense
//
//  Created by David Ferreira on 05/03/25.
//

import SwiftData
import SwiftUI

struct ExpensesView: View {
    @Environment(\.modelContext) var modelContext
    
    @Query var expenses: [ExpenseItem]
    
    let currencyFormat = Locale.current.currency?.identifier ?? "USD"
    
    
    var body: some View {
        List {
            ForEach(expenses) { expense in
                HStack {
                    VStack(alignment: .leading) {
                        Text(expense.name)
                            .font(.headline)
                        
                        Text(expense.type)
                    }
                    
                    Spacer()
                    
                    Text(expense.amount, format: .currency(code: currencyFormat))
                        .foregroundStyle(getAmountStyle(for: expense.amount))
                        .fontWeight(getAmountFontWeight(for: expense.amount))
                }
            }
            .onDelete(perform: deleteExpense)
        }
    }
    
    func deleteExpense(at offsets: IndexSet) {
        for offset in offsets {
            let expense = expenses[offset]
            modelContext.delete(expense)
        }
    }
    
    func getAmountStyle(for amount: Double) -> Color {
        switch amount {
        case ..<10:
            return .mint
        case 10..<100:
            return .blue
        default:
            return .red
        }
    }
    
    func getAmountFontWeight(for amount: Double) -> Font.Weight {
        switch amount {
        case ..<10:
            return .light
        case 10..<100:
            return .regular
        default:
            return .bold
        }
    }
    
    init(sortOrder: [SortDescriptor<ExpenseItem>], filter: String) {
        _expenses = Query(filter: #Predicate<ExpenseItem> { expense in
            filter == "Show all" ? true : expense.type == filter
        } ,sort: sortOrder)
    }
}

#Preview {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: ExpenseItem.self, configurations: config)
    let expense1 = ExpenseItem(name: "Test1", type: "Personal", amount: 5.0)
    let expense2 = ExpenseItem(name: "Test2", type: "Business", amount: 50.0)
    let expense3 = ExpenseItem(name: "Test3", type: "Personal", amount: 500.0)
    
    container.mainContext.insert(expense1)
    container.mainContext.insert(expense2)
    container.mainContext.insert(expense3)
    
    return ExpensesView(sortOrder: [
        SortDescriptor(\ExpenseItem.amount, order: .reverse),
        ], filter: "Show all")
        .modelContainer(container)
}
