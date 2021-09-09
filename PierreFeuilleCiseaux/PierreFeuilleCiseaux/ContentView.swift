//
//  ContentView.swift
//  PierreFeuilleCiseaux
//
//  Created by Theodor Brown on 20/08/2021.
//

import SwiftUI

struct ContentView: View {
    
    @State private var tab = ["pierre","feuille","ciseaux"]
    @State private var tabPosition = Int.random(in: 0...2)
    
    @State private var choixGagnant: Bool = Bool.random()
    @State private var alert: Bool = false
    @State private var score = 0

    
    var body: some View {
        VStack {
            VStack {
                Text("Bienvenue sur PFC")
                    .fontWeight(.semibold)
                    .font(.system(size: 30))
                    .padding()
                    .background(Color.orange.opacity(0.4))
                    .cornerRadius(16)
                    .padding()
                Text("L'ordinateur annonce : ")
                    .font(.title2)
                    .fontWeight(.semibold)
                Text(tab[tabPosition])
                    .font(.system(size: 40))
                    .fontWeight(.bold)
                    .padding()
                Text("Vous devez répondre \(choixGagnant.description == "true" ? "pour gagner." : "pour perdre.")")
                    .foregroundColor(.green)
                    .font(.title3)
                    .fontWeight(.medium)
                    .padding()
                Text("Faites votre choix :")
                    .font(.title2)
                    .fontWeight(.semibold)
                    .padding()
            }
            HStack {
                ForEach(tab,id:\.self){ image in
                    Button(action: {
                        if situation(choixGagnant, tab[tabPosition], image) {
                            score+=1
                        } else {
                            score-=1
                        }
                        reset()
                        whatScore()
                        
                        
                    }, label: {
                        Image(image)
                            .resizable()
                            .frame(width:100, height: 100)
                            .clipped()
                    })
                }
            }
            .padding()
            Spacer()
            Text("Votre score : \(score)")
                .fontWeight(.bold)
                .font(.title3)
                .foregroundColor(.blue)
        }
        .alert(isPresented: $alert, content: {
            Alert(title: Text("Bien joué !"), message: Text("Vous avez atteint le score de \(score)"), dismissButton: .default(Text("Rejouer")){
                score = 0
            })
        })
    }
    
    func situation(_ choixOrdi1: Bool, _ choixOrdi2: String, _ reponseJoueur: String) -> Bool {
        //gagnant -> Pierre -- Feuille, Feuille -- Ciseaux, Ciseaux -- Pierre
        switch choixOrdi2 {
        case "pierre":
            if choixOrdi1 {
                if reponseJoueur == "feuille" {
                    return true
                } else {
                    return false
                }
            } else {
                if reponseJoueur == "feuille" {
                    return false
                } else {
                    return true
                }
            }
        case "feuille":
            if choixOrdi1 {
                if reponseJoueur == "ciseaux" {
                    return true
                } else {
                    return false
                }
            } else {
                if reponseJoueur == "ciseaux" {
                    return false
                } else {
                    return true
                }
            }
        case "ciseaux":
            if choixOrdi1 {
                if reponseJoueur == "pierre" {
                    return true
                } else {
                    return false
                }
            } else {
                if reponseJoueur == "pierre" {
                    return false
                } else {
                    return true
                }
            }
        default:
            return false
        }
    }
    
    func whatScore(){
        if score > 9 {
            alert = true
        } else {
            alert = false
        }
    }
    
    
    func reset(){
        tabPosition = Int.random(in: 0...2)
        choixGagnant = Bool.random()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
