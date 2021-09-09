//
//  FlagImageView.swift
//  GuessTheFlag
//
//  Created by Theodor Brown on 18/08/2021.
//

import SwiftUI

struct FlagImageView: View {
    
    @Binding var tab : [String]
    var number : Int
    
    var body: some View {
        Image(tab[number])
            .clipShape(Rectangle())
            .cornerRadius(20)
            .shadow(radius: 30)
            .padding()
        
    }
}

struct FlagImageView_Previews: PreviewProvider {
    
    @State static var tab = ["France"]
    @State static var number = 0
    
    static var previews: some View {
        FlagImageView(tab: $tab, number: number)
    }
}
