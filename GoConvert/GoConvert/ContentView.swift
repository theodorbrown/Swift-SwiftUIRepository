//
//  ContentView.swift
//  GoConvert
//
//  Created by Theodor Brown on 16/08/2021.
//

import SwiftUI

struct ContentView: View{
    
    @State private var devise = "Températures"
    @State private var valeur = ""
    
    var resultat: Double {
        calcul(saisieUsr: valeur, unitd: uniteDepart, unita: uniteArrive)
    }
    
    @State private var uniteDepart = "-"
    @State private var uniteArrive = "-"
    
    let devises = ["Températures", "Longueurs", "Poids"]
    
    func displayUnits(devise : String)-> [String] {
        switch devise {
        case "Températures":
            return ["C°", "°F", "K"]
        case "Longueurs":
            return ["m", "mm"]
        case "Poids":
            return ["Kg", "g"]
        default:
            return [String]()
        }
    }
    
    func calcul(saisieUsr valeur: String, unitd: String, unita: String) -> Double {
        
        let convertValue = Double(valeur) ?? 0
        
        switch unitd {
        case "C°":
            if unita == "°F" { return (convertValue * 9/5) + 32 } else if unita == "K" { return convertValue + 273.15 } else { return convertValue }
        case "°F":
            if unita == "C°" { return (convertValue - 32) * (5/9) } else if unita == "K" { return (convertValue - 32) * 5/9 + 273.15 } else { return convertValue }
        case "K":
            if unita == "°F" { return (convertValue - 273.15) * 9/5 + 32 } else if unita == "C°" { return convertValue - 273.15 } else { return convertValue }
        case "m":
            if unitd != unita { return convertValue * 1000 } else { return convertValue }
        case "mm":
            if unitd != unita { return convertValue * 0.001 } else { return convertValue }
        case "Kg":
            if unitd != unita { return convertValue * 1000 } else { return convertValue }
        case "g":
            if unitd != unita { return convertValue * 0.001 } else { return convertValue }
        default:
            return convertValue
        }
    }
    
    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: [Color.purple, Color.orange]), startPoint: .top, endPoint: .bottom)
                .ignoresSafeArea()
            VStack {
                Text("Choisissez une devise :")
                    .fontWeight(.semibold)
                    .font(.title2)
                Picker(selection: $devise, label: Text("Devise"), content: {
                    ForEach(devises, id: \.self){ dev in
                        Text("\(dev)")
                    }
                })
                .pickerStyle(SegmentedPickerStyle())
                .padding()

                VStack{
                    Text("Saisissez une valeur :")
                        .font(.system(size: 20))
                    HStack {
                        Spacer()
                        TextField("0", text: $valeur)
                            .frame(minWidth:100, maxWidth: 100)
                            .multilineTextAlignment(.center)
                            .foregroundColor(.black)
                        Text("→")
                        Text("\(resultat, specifier: "%.2f")")
                            .frame(minWidth:100, maxWidth: 100)
                        Spacer()
                    }
                    .padding()
                }
                HStack{
                    Spacer()
                    Picker(selection: $uniteDepart, label: HStack {
                        Text("Unité :")
                        Text(uniteDepart)
                    }, content: {
                        ForEach(displayUnits(devise: devise),id : \.self) { unit in
                            Text("\(unit)")
                        }
                    })
                    .pickerStyle(MenuPickerStyle())
                    Spacer()
                    Picker(selection: $uniteArrive, label: HStack {
                        Text("Unité :")
                        Text(uniteArrive)
                    }, content: {
                        ForEach(displayUnits(devise: devise),id : \.self) { unit in
                            Text("\(unit)")
                        }
                    })
                    .pickerStyle(MenuPickerStyle())
                    Spacer()
                }
                .font(.system(size: 19))
                
                if (resultat != 0 && resultat != Double(valeur) ?? 0)  {
                    Text("Conversion réalisée avec succès.")
                        .foregroundColor(.green)
                        .font(.title3)
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
