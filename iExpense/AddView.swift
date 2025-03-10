//
//  AddView.swift
//  iExpense
//
//  Created by David Ferreira on 20/02/25.
//

import SwiftUI

struct AddView: View {
    @Environment(\.dismiss) var dismiss
    @Environment(\.modelContext) var modelContext
    
    @State private var name = "New Expense"
    @State private var type = "Personal"
    @State private var amount = 0.0
    
    let currencyFormat = Locale.current.currency?.identifier ?? "USD"
    
    let types = ["Business","Personal"]
    
    var body: some View {
        NavigationStack {
            Form {
                
                Picker("Type", selection: $type) {
                    ForEach(types, id: \.self) {
                        Text($0)
                    }
                }
                
                TextField("Amount", value: $amount, format: .currency(code: currencyFormat)).keyboardType(.decimalPad)
            }
            .navigationTitle($name)
            .toolbarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                        Button("Save") {
                            let item = ExpenseItem(name: name, type: type, amount: amount)
                            modelContext.insert(item)
                            dismiss()
                        }
                    }
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
        }
    }
}

#Preview {
    AddView()
}
