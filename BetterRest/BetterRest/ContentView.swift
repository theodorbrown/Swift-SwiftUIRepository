//
//  ContentView.swift
//  BetterRest
//
//  Created by Theodor Brown on 21/08/2021.
//

import SwiftUI

struct ContentView: View {
    
    //heures + minutes de levé
    @State private var wakeUp = defaultWakeUpTime
    //nombre d'heure de sommeil
    @State private var sleepAmout = 8.0
    //nombre de tasses de café
    @State private var coffeeAmout = 0
    
    //Pour l'alerte
    //@State private var alertTitle = ""
    //@State private var alertMessage = ""
    //@State private var showingAlert = false
    
    var body: some View {
        NavigationView {
            ZStack {
                Form {
                    Section(header: Text("A quelle heure voulez-vous vous lever ?")) {
                        DatePicker("Heure de levé", selection : $wakeUp, displayedComponents: .hourAndMinute)
                            .labelsHidden()
                            .datePickerStyle(WheelDatePickerStyle())
                    }
                    
                    Section(header: Text("Temps de sommeil désiré ?")) {
                        Stepper(value: $sleepAmout, in: 1...12, step: 0.25) {
                            Text("\(sleepAmout, specifier: "%g") heures")
                        }
                    }

                    Section(header: Text("Consommation de tasses de café :")) {
                        /*Stepper(value: $coffeeAmout, in: 0...20) {
                            if coffeeAmout < 2 {
                                Text("\(coffeeAmout) café ☕️")
                            } else {
                                Text("\(coffeeAmout) cafés ☕️")
                            }
                         }
                        */
                        Picker(selection: $coffeeAmout, label: Text(""), content: {
                            ForEach((0...20),id: \.self){
                                Text("\($0) cafés ☕️")
                            }
                        })
                        .pickerStyle(WheelPickerStyle())
                    }
                }
                
                VStack {
                    Text("L'heure idéale de votre couché est :")
                        .fontWeight(.semibold)
                    Text(alertMessage)
                        .font(.title3)
                        .fontWeight(.bold)
                }
                .font(.system(size: 15))
                .padding(8)
                .overlay(Capsule().stroke(LinearGradient(gradient: Gradient(colors: [Color.red, Color.blue]), startPoint: .leading, endPoint: .trailing), lineWidth: 2))
                .position(x: (UIScreen.main.bounds.width / 2), y: 690)
            }
            .navigationTitle("BetterRest 😴")
            /*.navigationBarItems(trailing: Button(action: calculateBedTime){
                Text("Calculer")
                Image(systemName: "wand.and.stars")
            })
            */
        }
        /*.alert(isPresented: $showingAlert, content: {
            Alert(title: Text(alertTitle), message: Text(alertMessage), dismissButton: .default(Text("Ok !")))
        })
         */
    }
    
    private var alertMessage: String {
        //format date heure + minutes
        //Un calendar est en fait un calendrier jour j de l'IPhone
        let components = Calendar.current.dateComponents([.hour,.minute], from: wakeUp)
        //heures en secondes
        let hour = (components.hour ?? 0) * 60 * 60
        //minutes en secondes
        let minute = (components.minute ?? 0) * 60
        
        //bloc do/catch pour utilisation du model
        do {
            //instance du model CoreML
            let model: SleepCalculator = try SleepCalculator(configuration: .init())
            //calcule de la prédication du temps de sommeil
            let prediction = try model.prediction(wake: Double(hour + minute), estimatedSleep: sleepAmout, coffee: Double(coffeeAmout))
            
            //Une date ressort : temps de sommeil calculé
            let sleepTime = wakeUp - prediction.actualSleep
            
            //convertit la date en joli
            let formatter = DateFormatter()
            formatter.timeStyle = .short
            
            return formatter.string(from: sleepTime)
            
            //alertTitle = "L'heure idéale de votre couché est :"
                        //on utilise le formatter
            //alertMessage = formatter.string(from: sleepTime)
            
        
        //en cas d'erreur
        } catch {
            //alertTitle = "Erreur"
            //alertMessage = "Désolé, nous n'avons pas pu calculer l'heure idéale de votre couché."
            return "Problème de conversion."
        }
        
        //showingAlert = true
        
    }
    
    //Static alors cette propriété appratient à la struct et non pas à une instance donc dispo à tout moment. De plus cette propriété n'utilise aucune valeurs attendue pour être définie
    static var defaultWakeUpTime: Date {
        var components = DateComponents()
        components.hour = 7
        components.minute = 0
        
        return Calendar.current.date(from: components)  ?? Date()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
