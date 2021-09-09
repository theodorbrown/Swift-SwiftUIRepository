//
//  ContentView.swift
//  Let'Split
//
//  Created by Theodor Brown on 12/08/2021.
//

import SwiftUI

struct ContentView: View {
    
    init() {
        UITableView.appearance().backgroundColor = .clear
    }
    
    @State private var dinnerPrice: String = ""
    @State private var nbPeople: Int = 0
    @State private var pourcentTip: Int = 0
    
    let pourcentages = [0, 5, 10, 15, 20, 25]
    
    var totalPerPerson: Double {
        
        let nbPeopleCast = Double(nbPeople + 2)
        let pourcentTipCast = Double(pourcentages[pourcentTip])
        let dinnerPriceCast = Double(dinnerPrice) ?? 0

        let tipValue = dinnerPriceCast / 100 * pourcentTipCast
        let total = dinnerPriceCast + tipValue
        let perPerson = total / nbPeopleCast

        return perPerson
    }
    
    var total: Double {
        
        let pourcentTipCast = Double(pourcentages[pourcentTip])
        let dinnerPriceCast = Double(dinnerPrice) ?? 0

        let tipValue = dinnerPriceCast / 100 * pourcentTipCast
        let total = dinnerPriceCast + tipValue

        return total
    }
    
    func comment(for price: Double) -> String {
        switch price {
        case 0.00000...0.99999: return ""
        case 1.00000...10.99999: return "On se ruine pas"
        case 11.00000...30.99999: return "C'est léger"
        case 31.00000...50.99999: return "C'est raisonnable"
        default: return "C'est excessif"
        }
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                Color("custom").ignoresSafeArea(.all)
                Form {
                    Section(header: Text("Prix de la note et nombre de personnes")) {
                        TextField("Somme", text: $dinnerPrice)
                            .keyboardType(.numbersAndPunctuation)
                        
                        Picker("Nombre de personnes", selection: $nbPeople) {
                            ForEach(2..<30) {
                                Text("\($0)")
                            }
                        }
                    }
                    .foregroundColor(.black)
                    Section(header: Text("Pourboire")) {
                        Picker("Pourboire", selection: $pourcentTip) {
                            ForEach(0..<pourcentages.count) {
                                Text("\(pourcentages[$0])%")
                            }
                        }
                        .pickerStyle(SegmentedPickerStyle())
                    }
                    .foregroundColor(.black)
                    Section(header: Text("Montant par personne")) {
                        Text("\(totalPerPerson, specifier: "%.2f")")
                            .foregroundColor(pourcentTip == 0 ? .red : .green)
                    }
                    .foregroundColor(.black)
                    
                    Section(header: Text("Montant total avec le pourboire")) {
                        Text("\(total, specifier: "%.2f")")
                            .foregroundColor(pourcentTip == 0 ? .red : .green)
                    }
                    .foregroundColor(.black)
                    
                    Section(header: Text("Commentaire de l'application")){
                     Text("\(comment(for: totalPerPerson))")
                    }
                    .foregroundColor(.black)
                }
                .navigationTitle("Let'Split")
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
