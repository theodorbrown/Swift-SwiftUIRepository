//
//  ContentView.swift
//  Animations
//
//  Created by Theodor Brown on 28/08/2021.
//

import SwiftUI

struct CornerRotateModifier : ViewModifier {
    let amount: Double
    let anchor: UnitPoint
    
    func body(content: Content) -> some View {
        content.rotationEffect(.degrees(amount), anchor: anchor)
            .clipped()
    }
    
}

extension AnyTransition {
    static var pivot: AnyTransition {
        .modifier(
            active: CornerRotateModifier(amount: -90, anchor: .topLeading),
            identity: CornerRotateModifier(amount: 0, anchor: .topLeading)
        )
    }
}

struct ContentView: View {
    
    @State private var animation: CGFloat = 0
    @State private var anim: CGSize = .zero
    
    let letters = Array("Hello SwiftUI")
    @State private var enabled = false
    @State private var dragAmount = CGSize.zero
    @State private var isShowingRed = false
    
    var body: some View {
        VStack {
            Button("Tap me") {

              }
              .padding(50)
              .background(Color.red)
              .foregroundColor(.white)
              .clipShape(Circle())
              .overlay(Circle()
                          .stroke(Color.red)
                          .scaleEffect(animation)
                        .opacity(Double(2.2 - animation))
                          .animation(
                            Animation.easeInOut(duration: 1)
                                  .repeatForever(autoreverses: false)
                          )
              )
              .onAppear {
                animation = 1.75
              }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
