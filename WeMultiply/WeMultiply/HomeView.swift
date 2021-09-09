//
//  HomeView.swift
//  WeMultiply
//
//  Created by Theodor Brown on 31/08/2021.
//
import SwiftUI

struct HomeView: View {
    
    @State private var animation: CGFloat = 0
    @State private var show: Bool = false
    
    @State private var isShowingSettings = false
    
    @State private var upToPicker = 2
    @State private var questionPicker = 1
    
    var body: some View {
        NavigationView {
            ZStack {
                Color("home.color").ignoresSafeArea(.all)
                VStack {
                    Spacer()
                    Text("Bienvenue, ici vous apprendrez les tables de multiplications et vous deviendrez un maître !")
                        .font(.title2)
                        .fontWeight(.semibold)
                        .multilineTextAlignment(.center)
                    Spacer()
                    ///
                    ButtonView(animation: $animation, show: $show,upToPicker: $upToPicker,questionPicker: $questionPicker)
                    ///
                    Spacer()
                }
                .navigationTitle("WeMultiply!")
                .navigationBarItems(trailing:
                    Button(action: {
                        isShowingSettings = true
                    }, label: {
                        Image(systemName: "gear")
                            .font(.title)
                            .foregroundColor(.black)
                    }).sheet(isPresented: $isShowingSettings){
                        SettingsView(upToPicker: $upToPicker, questionPicker: $questionPicker)
                    })
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
