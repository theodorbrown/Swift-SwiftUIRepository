//
//  ContentView.swift
//  iExpense
//
//  Created by Theodor Brown on 04/09/2021.
//

import SwiftUI

struct ExpenseItem: Identifiable, Codable {
    var id = UUID()
    let name: String
    let type: String
    let price: Int
}

class Expenses: ObservableObject {
    @Published var items = [ExpenseItem]() {
        //après chaque ajout dans le tableau on fait un save dans l'appareil.
        //on instancie un encoder JSON
        // on essaie d'encoder le tableau
        //le tableau contient des ExpenseItem donc ce dernier doit se conformer au protocol Codable
        //Succès ? --> on enregistre dans UserDefaults avec la clé Items.
        didSet {
            let encoder = JSONEncoder()
            if let encoded = try? encoder.encode(items){
                UserDefaults.standard.set(encoded, forKey: "Items")
            }
        }
    }
    
    init() {
        if let items = UserDefaults.standard.data(forKey: "Items") {
            let decoder = JSONDecoder()
            if let decoded = try? decoder.decode([ExpenseItem].self, from: items) {
                //attention self pour faire référence à la propriété de la struct et non pas à la variable dans le init()
                self.items = decoded
                return
            }
        }
        items = []
    }
}

struct ContentView: View {
    
    @ObservedObject var expenses = Expenses()
    @State private var isPresented = false
    
    var body: some View {
        NavigationView {
            List {
                ForEach(expenses.items){ item in
                    HStack {
                        VStack(alignment: .leading) {
                            Text("\(item.name)")
                                .font(.headline)
                            Text("\(item.type)")
                                .font(.subheadline)
                        }
                        Spacer()
                        if item.price < 11 {
                            HStack {
                                Text("\(item.price)€")
                                Image(systemName: "flag.fill")
                            }
                            .foregroundColor(.green)
                        } else {
                            HStack {
                                Text("\(item.price)€")
                                Image(systemName: "flag.fill")
                            }
                            .foregroundColor(item.price > 100 ? .red : .orange)
                        }
                    }
                }
                .onDelete(perform: removeItems)
            }
            .navigationBarItems(leading: EditButton(), trailing: Button(action: {
                isPresented = true
            }, label: {
                Image(systemName: "plus")
            }))
            .navigationTitle("iExpense")
        }
        .sheet(isPresented: $isPresented){
            AddView(expenses: expenses)
        }
    }
    
    func removeItems(at offsets: IndexSet){
        expenses.items.remove(atOffsets: offsets)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
