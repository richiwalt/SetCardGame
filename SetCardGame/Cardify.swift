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
    var dealFrom: CGSize = CGSize(width: Double.random(in: -1000...(-100)), height: Double.random(in: -800...(-100)) )
    @State private var isVisible: Bool = false
    // @State private var shuffleDelay: Double = 0.0

    /*
    var animatableData: AnimatablePair<CGFloat,CGFloat> {
        get {
            AnimatablePair(dealFrom.width, dealFrom.height)
        }
        set {
            dealFrom.width = CGFloat(newValue.first)
            dealFrom.height = CGFloat(newValue.second)
        }
    }
    */
    
    func body(content: Content)  -> some View {
        ZStack {
            
                        
            // if isVisible && !card.isMatched {
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
                        .rotation3DEffect(Angle.degrees(self.card.isMatched ? 360 : 0 ), axis: (0,1,0))
                        .animation(self.card.isMatched ? Animation.linear(duration: 0.6).repeatForever(autoreverses: false) : .default )
                        // .foregroundColor(self.card.color)
                            .foregroundColor(self.card.isOneOfThreeSelected && !self.card.isMatched ? Color.gray : self.card.color )

                    }
                }
                .padding() // for shape to card edge distance
                .scaleEffect(self.card.isSelected ? 0.60 : 1.0 )//.animation(.easeInOut(duration: 0.65))
                    .transition(.offset(dealFrom))
                
                
            }
            
        }
        
        .padding(5) // for Grid within GameBoard
        .aspectRatio(2.5/3, contentMode: .fit)
        .onAppear() {
            withAnimation(.easeInOut(duration: 2)) {
                self.isVisible = true
            }
        }
        .onDisappear() {
            withAnimation(.easeInOut(duration: 2)) {
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
