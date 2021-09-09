//
//  InPlayView.swift
//  WeMultiply
//
//  Created by Theodor Brown on 01/09/2021.
//

import SwiftUI

struct InPlayView: View {
    
    @Environment(\.presentationMode) var presentationMode
    
    @Binding var upToPicker: Int
    @Binding var questionPicker: Int
        
    //part de 0
    @State private var questionsTab: [Question] = []
    @State private var answersUsersTab: [String] = []
    
    @State private var userAnswer = ""
    
    @State private var isAppeared = false
    @State private var count = 0
    
    @State private var isShowingAlert = false
    
    //@State private var animation = false
    
    //passe pas en private
    @State private var animalsTab = ["bear","buffalo","chick","chicken","cow","crocodile","dog","duck","elephant","frog","giraffe","goat","gorilla","hippo","horse","monkey","moose","narwhal","owl","panda","parrot","penguin","pig","rabbit","rhino","sloth","snake","walrus","whale","zebra"].shuffled()
    
    private var animals: [String] {
        return [animalsTab[7], animalsTab[14]]
    }
    
    private let layout = [
        GridItem(.flexible(minimum : 25, maximum: 30)),
        GridItem(.flexible(minimum : 25, maximum: 30)),
        GridItem(.flexible(minimum : 25, maximum: 30))
    ]
    
    var body: some View {
        ZStack {
            Color("inplayview.color")
                .ignoresSafeArea(.all)
            VStack {
                if isAppeared {
                    HStack {
                        LazyVGrid(columns: layout, spacing: 5){
                            //0 1 2 3 4
                            ForEach(0..<questionsTab[count].operand1){ _ in
                                Image(animals[0])
                                    .resizable()
                                    .frame(width: 30, height: 30)
                            }
                        }
                        Text(" X ")
                        LazyVGrid(columns: layout, spacing: 5){
                            ForEach(0..<questionsTab[count].operand2){ _ in
                             Image(animals[1])
                                .resizable()
                                .frame(width: 30, height: 30)
                            }
                        }
                        Text(" = ")
                        TextField("", text: $userAnswer)
                            .keyboardType(.numberPad)
                            .frame(width: 30.0)
                            .font(.title3)
                            .padding(.horizontal, 10.0)
                            .padding(.vertical, 6.0)
                            .border(Color.black)
                            .background(Color.white)
                    }
                    .frame(height:200)

                    Button("Suivant") {
                        //user answer added
                        answersUsersTab.append(userAnswer)
                        userAnswer = ""
                        if count < (howManyQ() - 1) {
                            count+=1
                            isAppeared = false
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) {
                                isAppeared = true
                            }
                        } else {
                            isShowingAlert = true
                            isAppeared = false
                        }
                        animalsTab.shuffle()
                    }
                    .font(.title3)
                    .padding(.horizontal, 25.0)
                    .padding(.vertical, 16.0)
                    .background(Color("button.color"))
                    .foregroundColor(.black)
                    .cornerRadius(20)
                }
            }
        }
        .onAppear{
            generator(nbQuestions: howManyQ(), upToTable: howManyT())
            isAppeared = true
        }
        .alert(isPresented: $isShowingAlert, content: {
            Alert(title: Text("Partie terminée !"), message: Text("Votre score est de \(calcScore()) / \(howManyQ())"), dismissButton: .default(Text("Terminé")){
                presentationMode.wrappedValue.dismiss()
            })
        })
    }
    
    func howManyQ() -> Int {
        switch questionPicker {
        case 1:
            return 10
        case 2:
            return 20
        case 3:
            return 30
        case 4:
            return 40
        case 5:
            return 144
        default:
            return 0
        }
    }
    
    func howManyT() -> Int {
        switch upToPicker {
        case 1:
            return 2
        case 2:
            return 4
        case 3:
            return 6
        case 4:
            return 8
        case 5:
            return 10
        case 6:
            return 12
        default:
            return 0
        }
    }
    
    func generator(nbQuestions: Int, upToTable: Int) {
        for _ in (1...nbQuestions) {
            let o1 = Int.random(in: 1...upToTable)
            let o2 = Int.random(in: 1...12)
            let calc = o1 * o2
            let question = Question(operand1: o1, operand2: o2, calc: calc)
            questionsTab.append(question)
        }
    }
    
    func calcScore() -> Int {
        var score = 0
        // 0 si l'user rentre autre chause que du int
        let intArray = answersUsersTab.map { Int($0) ?? 0}
        for i in 0...(howManyQ() - 1) {
            if (questionsTab[i].calc == intArray[i]){
                score+=1
            }
        }
        return score
    }
}

struct InPlayView_Previews: PreviewProvider {
    
    @State static private var upToPicker = 1
    @State static private var questionPicker = 1
    
    static var previews: some View {
        InPlayView(upToPicker: $upToPicker, questionPicker: $questionPicker)
    }
}
