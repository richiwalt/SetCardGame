//
//  ContentView.swift
//  SetCardGame
//
//  Created by Walters on 6/25/20.
//  Copyright © 2020 Richard Walters. All rights reserved.
//

import SwiftUI


enum CardShape: String {
    case diamond, squiggle, circle
}


struct SetCardGameView: View {
    
    @ObservedObject var viewModel: SetGameViewModel
    
    var body: some View {
        
        ZStack {
            GeometryReader { geometry in
                
                VStack {
                    
                    Grid(self.viewModel.cards) { card in
                        SetCardView(viewModel: self.viewModel,
                                    card: card,
                                    cardPips:
                                    card.cardNumber,
                                    shading: card.cardShading,
                                    color: card.cardColor == "red" ? .red : card.cardColor == "green" ? .green : .purple )
                    }
                    
                }
            }
        }
    }
}



struct SetCardView: View {
    
    @ObservedObject var viewModel: SetGameViewModel
    var card: SetGame.SetCard
    var cardPips: Int
    var shading: Double
    var color: Color
    
    var body: some View {
        
        ZStack {
            
            VStack {
                if card.cardShape == "diamond" {
                    ForEach( 0..<cardPips ) { _ in
                        ZStack {
                            SetDiamond().opacity(self.card.cardShading)
                            SetDiamond().stroke()
                        }
                        //.aspectRatio(2.0, contentMode: .fit)
                    }
                }

                if card.cardShape == "oval" {
                    ForEach( 0..<cardPips ) { _ in
                        ZStack {
                            Circle().opacity(self.card.cardShading)
                            Circle().stroke()
                        }
                        //.aspectRatio(2.0, contentMode: .fit)
                    }
                }
                if card.cardShape == "squiggle" {
                    ForEach( 0..<cardPips ) { _ in
                        ZStack {
                            SetSquiggle().opacity(self.card.cardShading)
                            SetSquiggle().stroke()
                        }
                        //.aspectRatio(3.0, contentMode: .fit)
                    }
                }

            }
            .padding()
            .foregroundColor(self.color)
        
        }
    }
}






struct SetCardGameView_Previews: PreviewProvider {
    static var previews: some View {
        SetCardGameView(viewModel: SetGameViewModel() )
    }
}
