//
//  AddView.swift
//  iExpense
//
//  Created by Theodor Brown on 04/09/2021.
//

import SwiftUI

struct AddView: View {
    
    @ObservedObject var expenses: Expenses
    @Environment(\.presentationMode) var presentationMode
    
    static let types = ["Personnal","Work"]
    @State private var name = ""
    @State private var type = "Personnal"
    @State private var price = ""
    
    @State private var isShowingAlert = false
    
    var body: some View {
        NavigationView {
            Form {
                TextField("Name", text: $name)
                
                Picker("Type", selection: $type){
                    ForEach(Self.types, id: \.self){
                        Text($0)
                    }
                }
                .pickerStyle(WheelPickerStyle())
                
                TextField("Price", text: $price)
                    .keyboardType(.numberPad)
            }
            .navigationTitle("Add an item")
            .navigationBarItems(trailing: Button(action: {
                if let actualAmout = Int(price) {
                    let item = ExpenseItem(name: name, type: type, price: actualAmout)
                    expenses.items.append(item)
                    presentationMode.wrappedValue.dismiss()
                } else {
                    isShowingAlert = true
                }
            }, label: {
                Text("Save")
            }))
        }
        .alert(isPresented: $isShowingAlert, content: {
            Alert(title: Text("Erreur"), message: Text("Vous avez saisis des caractères interdits pour le prix de l'item."), dismissButton: .default(Text("Recommncer")))
        })
    }
}

struct AddView_Previews: PreviewProvider {
    static var previews: some View {
        AddView(expenses: Expenses())
    }
}
