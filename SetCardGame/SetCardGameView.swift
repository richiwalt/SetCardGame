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


func getShape(_ shape: ViewCardShape ) -> some Shape {
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
    var disgardTo: CGSize = CGSize(width: Double.random(in: 100...(1000)), height: Double.random(in: -800...(-100)) )
    
    var body: some View {
        
        return ZStack {
            
            LinearGradient(gradient: Gradient(colors: self.viewModel.theme.colorGradient ), startPoint: .topLeading, endPoint: .bottomTrailing).edgesIgnoringSafeArea(.all)
            
            GeometryReader { geometry in
                
                VStack {
                    
                    HStack {
                        
                        // New Game
                        Button(action: {
                            withAnimation(.easeInOut(duration: 0.75)) {
                                self.viewModel.createNewGame()
                            }
                            
                        }) { Text("Reset")}
                        .font(.headline)
                        
                        Spacer()
                        
                        // Change Theme
                        Button(action: {
                            withAnimation(.easeInOut(duration: 0.75)) {
                                self.viewModel.changeTheme()
                            }
                            
                        }) { Text("Theme")}
                            .font(.headline)

                        Spacer()
                        
                        // Deal Three Cards
                        Button(action: {
                            withAnimation {
                                self.viewModel.callModelDealThreeMoreCards()
                            }
                            
                        }) { Text("Deal")}
                        .font(.headline)
                            .foregroundColor(self.viewModel.noRemainingCards ?  .white : .white)
                            .disabled(self.viewModel.noRemainingCards)
                        Spacer()
                        
                        // Rearrange
                        Button(action: {
                            withAnimation(.easeIn(duration: 0.85)) {
                                self.viewModel.rearrangeCardsForView()
                            }
                            
                        }) { Text("Shuffle")}
                        .font(.headline)
                        
                        Spacer()
                        
                        // Score
                        Text("Found:\(self.viewModel.score)/27").animation(.none)
                        
                    }
                    .foregroundColor(.white)
                    
                    
                    Grid(self.viewModel.cards) { card in
                        
                        SetCard(card: card)
                            // i think .transition( works here because card is Identifiable ...
                            .transition( .offset(self.disgardTo) ).animation(.easeInOut(duration: 0.6))
                            .onTapGesture {
                                withAnimation {
                                    self.viewModel.touch(viewCard: card)
                                }
                        }
                    }
                        
                        
                        
                    .frame(width: geometry.size.width, height: geometry.size.height * 0.85 )
                    
                    Spacer()
                        
                    // Game Comments
                    Text("\(self.viewModel.gameComments)").animation(.none)
                        .font(.callout)
                        .multilineTextAlignment(.leading)
                        .foregroundColor(.white)
                   
                }
                
            }
            .padding()
        }
    }
}



struct SetCard: View {
    
    let card: CardForView
    
    var body: some View {
        
        ZStack {
            getShape( self.card.shape )
                .cardify(card: self.card)
        }
    }
}






struct SetCardGameView_Previews: PreviewProvider {
    static var previews: some View {
        SetCardGameView(viewModel: SetGameViewModel() )
    }
}


