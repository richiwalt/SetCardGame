//
//  ContentView.swift
//  SetCardGame
//
//  Created by Walters on 6/25/20.
//  Copyright © 2020 Richard Walters. All rights reserved.
//

import SwiftUI

/*
enum CardShape: String {
    case diamond, squiggle, circle
}
*/


struct AnyShape: Shape {
    
    func path(in rect: CGRect) -> Path {
        return _path(rect)
    }
    
    init<S: Shape>(_ wrapped: S) {
        _path = { rect in
            let path = wrapped.path(in: rect)
            return path
        }
    }
    private let _path: (CGRect) -> Path
}


func getShape(_ shape: SetCardShape ) -> some Shape {
    switch shape {
    case .circle:
        return AnyShape( Circle() )
    case .diamond:
        return AnyShape( SetDiamond() )
    case .squiggle:
        return AnyShape( SetSquiggle() )
    }
}


struct SetCardGameView: View {
    
    @ObservedObject var viewModel: SetGameViewModel
    
    var body: some View {
        
        ZStack {
            
            GeometryReader { geometry in
                
                VStack {
                    
                    Spacer()
                    
                    //SetCard(pips: 2, shape: .squiggle, color: .purple, shading: SetShading.striped.rawValue)
                    
                    Grid(self.viewModel.cards) { card in
                        
                        SetCard(pips: card.pips,
                                shape: card.shape,
                                color: card.color,
                                shading: card.shading, isSelected: card.isSelected
                        )
                        
                        .onTapGesture {
                            withAnimation(.easeInOut(duration: 0.40)) {
                                self.viewModel.touch(viewCard: card)
                            }
                            
                        }
                    }
                        
                    .frame(width: geometry.size.width, height: geometry.size.height * 0.75 )
                    
                    Spacer()
                    
                    // Bottom Menue
                    HStack {
                        
                        VStack {
                            
                            // New Game
                            Button(action: {
                                withAnimation(.easeInOut(duration: 2.0)) {
                                    self.viewModel.createNewGame()
                                }
                                
                            }) { Text("Reset Game")}
                            Spacer()
                            
                            // Deal Three Cards
                            Button(action: {
                                withAnimation(.easeInOut(duration: 0.85)) {
                                    self.viewModel.callModelDealThreeMoreCards()
                                }
                                
                            }) { Text("Deal 3")}
                            Spacer()
                            
                            // Rearrange
                            Button(action: {
                                withAnimation(.easeIn(duration: 0.85)) {
                                    self.viewModel.rearrangeCardsForView()
                                }
                                
                            }) { Text("Rearrange")}
                            Spacer()
                            
                                // Score
                            Text("Matches: \(self.viewModel.score)/27")
                            
                        }
                        .padding()
                        Spacer()
                        
                        // Game Comments
                        ZStack {
                            // RoundedRectangle(cornerRadius: 10)
                            RoundedRectangle(cornerRadius: 10).stroke()
                            Text("\(self.viewModel.gameComments)")
                            
                        }
                    }
                }
                // .background(Color.green)
            }
        .padding()
        }
    }
}



struct SetCard: View {
    
    let pips: Int
    let shape: SetCardShape
    let color: Color
    let shading: Double
    let isSelected: Bool
    
    var body: some View {
        ZStack {
            VStack {
                ForEach( 0..<pips ) { _ in
                    ZStack {
                        getShape( self.shape ).opacity(self.shading).foregroundColor(self.color)
                        getShape( self.shape ).stroke().foregroundColor(self.color)
                    }
                }
            }
            .padding()
            RoundedRectangle(cornerRadius: 10).stroke(lineWidth: isSelected ? 3.0 : 1.0).foregroundColor(.orange)
                
        }
    .scaleEffect(isSelected ? 0.60 : 1.0 )
    .padding(5)
    }
}






struct SetCardGameView_Previews: PreviewProvider {
    static var previews: some View {
        SetCardGameView(viewModel: SetGameViewModel() )
    }
}


