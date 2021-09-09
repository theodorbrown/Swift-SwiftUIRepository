//
//  ContentView.swift
//  WordScramble
//
//  Created by Theodor Brown on 25/08/2021.
//

import SwiftUI

struct ContentView: View {
    
    @State private var usedWords = [String]()
    @State private var rootWord = ""
    @State private var newWord = ""
    
    //alert
    @State private var alertTitle = ""
    @State private var alertMessage = ""
    @State private var showAlert = false
    
    //score
    private var score: Int {
        var temp = 0
        for word in usedWords {
            temp += word.count
        }
        return temp
    }
    
    var body: some View {
        NavigationView {
            VStack {
                TextField("Enter a new word", text: $newWord, onCommit: addNewWord)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .autocapitalization(.none)
                    .padding()
                
                List(usedWords, id: \.self){
                    Text($0)
                    Image(systemName: "\($0.count).circle")
                }
                    Text("Your score is \(score)")
            }
            .navigationTitle(Text(rootWord))
            .onAppear(perform: startGame)
            .navigationBarItems(trailing: Button(action: {
                startGame()
                usedWords = [String]()
            }, label: {
                Text("New word !")
            }))
        }
        .alert(isPresented: $showAlert, content: {
            Alert(title: Text(alertTitle), message: Text(alertMessage), dismissButton: .default(Text("Ok")))
        })
    }
    
    func addNewWord() {
        let answer = newWord.lowercased().trimmingCharacters(in: .whitespacesAndNewlines)
        
        guard answer.count > 0 else {
            return
            //== à un exit
        }
        
        guard isOriginal(word: newWord) else {
            return wordError(title: "This word exists already", message: "T'es pas créatif !")
        }
        
        guard isPossible(word: newWord) else {
            return wordError(title: "This word is not recognized", message: "Tu fabriques des mots maintenant ?")
        }
        
        guard isReal(word: newWord) else {
            return wordError(title: "This word doesn't exist in the dico", message: "Tu refais la langue de Shakespear ??")
        }
        
        guard isLongEnough(word: newWord) else {
            return wordError(title: "This word is too short", message: "Les mots de moins de trois lettres ne sont pas acceptés.")
        }
        
        guard isNotStartWord(word: newWord) else {
            return wordError(title: "This word is the given word", message: "Tu ne peux pas donner le mot de départ.")
        }
        
        usedWords.insert(answer, at: 0)
        newWord = ""
    }
    
    func startGame() {
        // 1. Find the URL for start.txt in our app bundle
        if let startWordsURL = Bundle.main.url(forResource: "start", withExtension: "txt") {
            // 2. Load start.txt into a string
            if let startWords = try? String(contentsOf: startWordsURL) {
                // 3. Split the string up into an array of strings, splitting on line breaks
                let allWords = startWords.components(separatedBy: "\n")

                // 4. Pick one random word, or use "silkworm" as a sensible default
                rootWord = allWords.randomElement() ?? "silkworm"

                // If we are here everything has worked, so we can exit
                return
            }
        }

        // If were are *here* then there was a problem – trigger a crash and report the error
        fatalError("Could not load start.txt from bundle.")
    }
    
    //Vérifie si le mot saisit est unique dans le tableau
    func isOriginal(word: String) -> Bool {
        !usedWords.contains(word)
    }
    
    func isPossible(word: String) ->Bool {
        // Variable temporaire qui copie le mot root en minuscule
        var tempWord = rootWord.lowercased()
        
        //pour chaque lettre du mot saisit par l'usr on regarde si elle existe dans le tempWord, alors on boucle jusqu'à la fin et on retourne true
        for letter in word {
            if let pos = tempWord.firstIndex(of: letter) {
                tempWord.remove(at: pos)
            } else {
                //sinon c'est que le mot existe pas si la lettre du mot saisie est introuvable dans le mot root donc on retourne false !
                return false
            }
        }
        return true
    }
    
    func isReal(word: String) -> Bool {
        //correcteur d'orthographe
        let checker = UITextChecker()
        
        let range = NSRange(location: 0, length: word.utf16.count)
        //check le dico pour savoir si le mot existe et renvoie un NSRange
        let misspelledRange = checker.rangeOfMisspelledWord(in: word, range: range, startingAt: 0, wrap: false, language: "en")

        return misspelledRange.location == NSNotFound
        //si NSNotFound  renvoie true
    }
    
    func isLongEnough(word: String) -> Bool {
        word.count > 3
    }
    
    func isNotStartWord(word: String) -> Bool {
        !(rootWord == word)
    }
    
    func wordError(title: String, message: String){
        alertTitle = title
        alertMessage = message
        showAlert = true
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
