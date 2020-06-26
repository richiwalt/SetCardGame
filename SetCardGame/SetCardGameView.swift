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
                    
                    Spacer()
                    
                    Grid(self.viewModel.cards) { card in
                        SetCardView(viewModel: self.viewModel,
                                    card: card,
                                    cardPips:
                                    card.cardNumber,
                                    shading: card.cardShading,
                                    shapeColor: card.cardColor == "red" ? .red : card.cardColor == "green" ? .green : .purple ).onTapGesture {
                                            self.viewModel.chooseCard(card: card)
                                        
                                        
                        }
                    
                    }
                
                    .frame(width: geometry.size.width, height: geometry.size.height * 0.85 )
                    
                    Spacer()
                    
                    // Bottom Menue
                    HStack {
                        
                        VStack {
                            
                            
                            // New Game
                            Button(action: {
                                self.viewModel.createNewGame()
                            }) { Text("Reset Game")}
                            
                            
                            
                            // Deal Three Cards
                            Button(action: {
                                self.viewModel.callModelDealThreeMoreCards()
                            }) { Text("Deal 3")}
                            .padding()
                        
                        }
                        .padding()
                        Spacer()
                        
                        // Game Comments
                        ZStack {
                            // RoundedRectangle(cornerRadius: 10)
                            RoundedRectangle(cornerRadius: 10).stroke().padding()
                            Text("\(self.viewModel.gameComments)")
                            
                        }
                        
                        
                    }
                }
                // .background(Color.green)
            }
        }
    }
}




struct SetCardView: View {
    
    @ObservedObject var viewModel: SetGameViewModel
    var card: SetGame.SetCard
    var cardPips: Int
    var shading: Double
    var shapeColor: Color
    
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
            //  .background(Color.white)
            .padding(10) // padding for cardShape
            .foregroundColor(self.shapeColor) // color of shapes
            
                        RoundedRectangle(cornerRadius: 10).stroke().foregroundColor(Color.orange)
            // RoundedRectangle of entire VStack (a card)
            
        }
        .padding(5) // padding between cards
        
    }
}






struct SetCardGameView_Previews: PreviewProvider {
    static var previews: some View {
        SetCardGameView(viewModel: SetGameViewModel() )
    }
}
