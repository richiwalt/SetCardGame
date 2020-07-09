//
//  Cardify.swift
//  SetCardGame
//
//  Created by Walters on 7/8/20.
//  Copyright © 2020 Richard Walters. All rights reserved.
//

import SwiftUI

struct Cardify: AnimatableModifier {
    let card: CardForView
    let dealFrom: CGSize = CGSize(width: Int.random(in: -1000...(-100)), height: Int.random(in: -800...(-100)) )
    @State private var isVisible: Bool = false
    // @State private var shuffleDelay: Double = 0.0
    
    
    func body(content: Content)  -> some View {
        ZStack {
                        
            if isVisible {
                
                Group {
                    RoundedRectangle(cornerRadius: 10).fill(Color.white).opacity(card.isSelected ? 1.0 : 1.0 )
                        .shadow(color: .black, radius: 10, x: 10, y: 13)
                    
                    RoundedRectangle(cornerRadius: 10).stroke(lineWidth: card.isSelected ? 1.0 : 1.3).foregroundColor(.accentColor)
                        //.shadow(color: .black, radius: 1, x: 2, y: 2)
                }
                .scaleEffect(self.card.isSelected ? 0.60 : 1.0 )//.animation(.easeInOut(duration: 0.65))
                //.shadow(radius: 10)
                
                .transition(.offset(self.dealFrom))// .animation(Animation.easeOut.delay(  card.delay   ))
                
                
                
                VStack {
                    
                    ForEach( 0..<card.pips ) { _ in
                        
                        ZStack {
                            content.opacity(self.card.shading).shadow(color: .black, radius: 1, x: 1.5, y: 1.5)
                            
                            getShape(self.card.shape)
                                .stroke(lineWidth: 2)
                                .opacity(self.card.shading < 0.1 ? 1.0 : 0.0)
                        }
                        
                        .foregroundColor(self.card.color)
                    }
                }
                .padding() // for shape to card edge distance
                .scaleEffect(self.card.isSelected ? 0.60 : 1.0 )//.animation(.easeInOut(duration: 0.65))
                .transition(.offset(self.dealFrom))
                
                
            }
            
        }
        
        .padding(5) // for Grid within GameBoard
        .aspectRatio(2.5/3, contentMode: .fit)
        .onAppear() {
            withAnimation(.easeInOut(duration: 0.75)) {
                self.isVisible = true
            }
        }
        .onDisappear() {
            withAnimation(.easeInOut(duration: 0.75)) {
                self.isVisible = true
            }
        }
    }
}


extension View {
    func cardify(card: CardForView) -> some View {
        return self.modifier(Cardify(card: card))
    }
}


extension AnyTransition {
    static var fromRandomToRandom: AnyTransition {
        // let insertion = AnyTransition.offset( CGSize( width: Int(arc4random()), height: Int(arc4random()) ) )
        // let removal = AnyTransition.offset(CGSize( width: Int(arc4random()), height: Int(arc4random()) ) )
        
        let insertion = AnyTransition.offset( CGSize( width: Int.random(in: -200...200), height: Int.random(in: -400...400) ) )
        let removal = AnyTransition.offset( CGSize( width: Int.random(in: -200...200), height: Int.random(in: -400...400) ) )
        return .asymmetric(insertion: insertion, removal: removal)
    }
}
