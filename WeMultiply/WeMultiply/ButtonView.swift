//
//  ButtonView.swift
//  WeMultiply
//
//  Created by Theodor Brown on 31/08/2021.
//

import SwiftUI

struct ButtonView: View {
    
    @Binding var animation: CGFloat
    @Binding var show: Bool
    
    ///
    @Binding var upToPicker: Int
    @Binding var questionPicker: Int
    @State private var isPresented = false
    ///
    
    var body: some View {
        VStack {
            Button("Jouer !") {
                ///
                isPresented = true
                ///
            }
            .padding(40)
            .font(.title3.weight(.semibold))
            .background(Color("button.color"))
            .foregroundColor(.black)
            .clipShape(Circle())
            .overlay(Circle()
                        .stroke(Color("button.color"), lineWidth: 2)
                        .scaleEffect(animation)
                        .opacity(Double(2 - animation))
                        .animation(Animation
                                    .easeInOut(duration: 1)
                                    .repeatForever(autoreverses: false), value: show
                        )
            )
            .onAppear{
                animation = 1.75
                show = true
            }
            ///
            .sheet(isPresented: $isPresented, content: {
                InPlayView(upToPicker: $upToPicker, questionPicker: $questionPicker)
            })
            ///
        }
    }
}

struct ButtonView_Previews: PreviewProvider {
    
    @State static private var animation: CGFloat = 0
    @State static private var show: Bool = false
    ///
    @State static private var upToPicker = 1
    @State static private var questionPicker = 1
    ///
    
    static var previews: some View {
        ButtonView(animation: $animation, show: $show,upToPicker: $upToPicker,questionPicker: $questionPicker)
            .previewLayout(.sizeThatFits)
    }
}
