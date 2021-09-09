//
//  ContentView.swift
//  GuessTheFlag
//
//  Created by Theodor Brown on 16/08/2021.
//

import SwiftUI

struct ContentView: View {
    
    @State private var countries = ["Estonia", "France", "Germany", "Ireland", "Italy", "Monaco", "Nigeria", "Poland", "Russia", "Spain", "UK", "US"].shuffled()
    
    //chiffre aléatoire compris entre 0 et 2
    @State private var correctAnswer = Int.random(in: 0...2)
    
    //Score du joueur
    @State private var score = 0
    //Message de score
    @State private var message = ""
    
    @State private var animation: Double = 0
    @State private var animation2: Double = 0
    @State private var selectedNum = 99
    @State private var isRight = false
    @State private var isWrong = false
    
    @State private var isShowingAlert = false
    @State private var count = 0
    
    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: [.yellow, .blue]), startPoint: .top, endPoint: .bottom)
                .ignoresSafeArea(.all)
            VStack(spacing: 20) {
                Text("Tap the flag...")
                    .font(.title)
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
                Text(countries[correctAnswer])
                    .foregroundColor(.white)
                    .font(.largeTitle)
                    .fontWeight(.black)
                VStack{
                    // 0 1 2
                    ForEach(0 ..< 3) { number in
                        Button(action: {
                            withAnimation() {
                                isItCorrect(number)
                            }
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.75) {
                                reset()
                            }
                        }, label: {
                            FlagImageView(tab: $countries, number: number)
                                .rotation3DEffect(.degrees(animation), axis: (x: 0, y: number == correctAnswer ? 1 : 0 , z: 0))
                                //opacity vrai donc on est sur le correct answer donc on va réduire les autres drapeaux
                                .opacity(isRight && (selectedNum != number) ? 0.25 : 1)
                                .rotation3DEffect(.degrees(animation2), axis: (x: 0, y: 0, z: isWrong && (selectedNum == number) ? 1 : 0))
                        })
                    }
                }
                
                VStack {
                    Text("Ton score est de : \(score)")
                        .fontWeight(.semibold)
                    Spacer()
                    Text(message)
                        .fontWeight(.semibold)
                }
                .foregroundColor(.white)
                .font(.title2)
                
                Spacer()
            }
        }
        .alert(isPresented: $isShowingAlert) {
            Alert(title: Text("Fin de la partie"), message: Text("Votre score pour cette partie est de \(score)/10"), dismissButton: .default(Text("Rejouer")) {
                reset()
                score = 0
            })
        }
    }
    
    func isItCorrect (_ number: Int){
        selectedNum = number
        if number == correctAnswer {
            score+=1
            isRight = true
            animation+=360
            message = "C'est exact !"
        } else {
            score-=1
            isWrong = true
            animation2+=1000
            message = "Faux ! C'est le drapeau de : \(countries[number])"
        }
        count+=1
        if count > 9 {
            isShowingAlert = true
            count = 0
        }
    }
    
    func reset(){
        //on re shuffle le tab countries et on random le nombre
        correctAnswer = Int.random(in: 0...2)
        countries.shuffle()
        isRight = false
        isWrong = false
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
