//
//  SettingsView.swift
//  WeMultiply
//
//  Created by Theodor Brown on 31/08/2021.
//

import SwiftUI

struct SettingsView: View {

    @Binding var upToPicker: Int
    @Binding var questionPicker: Int
    
    //Sheet on/off
    @Environment(\.presentationMode) var presentationMode
    
    //up to dico : de 1 à 6 compris
    let upToDico = [1: "2", 2: "4", 3: "6", 4: "8", 5: "10", 6: "Toutes"]
    // question dico : de 10 à toutes les combinaisons
    let questionDico = [1: "10", 2: "20", 3: "30", 4: "40", 5: "Toutes les combinaisons"]
    
    var body: some View {
        VStack {
            NavigationView {
                Form {
                    Section(header : Text("Jusque quelle table (max 12)")){
                        Picker("upToPicker", selection: $upToPicker, content: {
                            ForEach(1...6, id: \.self){
                                Text("\(upToDico[$0]!)")
                            }
                        })
                        .pickerStyle(SegmentedPickerStyle())
                    }
                    Section(header : Text("Combien de questions")){
                        Picker("questionPicker", selection: $questionPicker, content: {
                            ForEach(1...5, id: \.self){
                                Text("\(questionDico[$0]!)")
                            }
                        })
                        .pickerStyle(WheelPickerStyle())
                    }
                    Button(action: {
                        presentationMode.wrappedValue.dismiss()
                    }, label: {
                        HStack {
                            Spacer()
                            Text("Enregistrer")
                                .font(.title3)
                                .foregroundColor(.black)
                            Spacer()
                        }
                    })
                    .listRowInsets(.init())
                    .listRowBackground(Color("home.color"))
                    .frame(height: 50)
                    .multilineTextAlignment(.center)
                }
                .navigationTitle("Réglages")
            }
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    
    @State static private var upToPicker = 2
    @State static private var questionPicker = 1
    
    static var previews: some View {
        SettingsView(upToPicker: $upToPicker, questionPicker: $questionPicker)
    }
}
