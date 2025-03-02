//
//  ContentView.swift
//  iExpense
//
//  Created by David Ferreira on 19/02/25.
//

import SwiftUI

struct ExpenseItem: Identifiable, Codable {
    var id = UUID()
    let name: String
    let type: String
    let amount: Double
}

@Observable
class Expenses {
    var items = [ExpenseItem]() {
        didSet {
            if let encoded = try? JSONEncoder().encode(items) {
                UserDefaults.standard.set(encoded, forKey: "Items")
            }
        }
    }
    
    init() {
        if let savedItems = UserDefaults.standard.data(forKey: "Items") {
            if let decodedItems = try? JSONDecoder().decode([ExpenseItem].self, from: savedItems) {
                items = decodedItems
                return
            }
        }
        
        items = []
    }
}

struct ContentView: View {
    @State private var expenses = Expenses()
    @State private var showingSheet = false
    
    let currencyFormat = Locale.current.currency!.identifier
    
    var personalItems: [ExpenseItem] {
        var result = expenses.items.filter {$0.type == "Personal"}
        result.sort { return $0.amount < $1.amount}
        return result
    }

    var businessItems: [ExpenseItem] {
        var result =  expenses.items.filter {$0.type == "Business"}
        result.sort { return $0.amount < $1.amount}
        return result
    }
    
    var body: some View {
        NavigationStack {
            List{
                Section(personalItems.isEmpty ? "" : "Personal items") {
                    ForEach(personalItems) { item in
                        HStack {
                            VStack(alignment: .leading) {
                                Text(item.name)
                                    .font(.headline)
                                
                                Text(item.type)
                            }
                            
                            Spacer()
                            
                            Text(item.amount, format: .currency(code: currencyFormat))
                                .foregroundStyle(getAmountStyle(for: item.amount))
                                .fontWeight(getAmountFontWeight(for: item.amount))
                        }
                    }
                    .onDelete { offsets in
                        removeItems(at: offsets, type: "Personal")
                    }
                }
                
                Section(businessItems.isEmpty ? "" :"Business items") {
                    ForEach(businessItems) { item in
                        HStack {
                            VStack(alignment: .leading) {
                                Text(item.name)
                                    .font(.headline)
                                
                                Text(item.type)
                            }
                            
                            Spacer()
                            
                            Text(item.amount, format: .currency(code: currencyFormat))
                                .foregroundStyle(getAmountStyle(for: item.amount))
                                .fontWeight(getAmountFontWeight(for: item.amount))

                        }
                    }
                    .onDelete { offsets in
                        removeItems(at: offsets, type: "Business")
                    }
                }
                
            }
            .navigationTitle("iExpense")
            .toolbar {
//                Button("Add expense", systemImage: "plus") {
//                    showingSheet.toggle()
//                }
                NavigationLink("Add expense") {
                    AddView(expenses: expenses)
                        .navigationBarBackButtonHidden()
                }
            }
//            .sheet(isPresented: $showingSheet, content: {
//                AddView(expenses: expenses)
//            })
        }
    }
    
    func removeItems(at offsets: IndexSet, type: String) {
        let itemsList = type == "Personal" ? personalItems : businessItems
        
        // Obter os itens que precisam ser removidos com base no tipo e índices
        let itemsToRemove = offsets.map { itemsList[$0] }
            
        // Filtrar os itens da lista principal e remover os itens com o ID correspondente
        expenses.items.removeAll { item in
            itemsToRemove.contains { $0.id == item.id }
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
}

#Preview {
    ContentView()
}
