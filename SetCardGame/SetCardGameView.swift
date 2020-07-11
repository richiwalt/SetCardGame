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
        
        ZStack {
            
            (LinearGradient(gradient: Gradient(colors: [.yellow, .orange, .red, .purple]), startPoint: .topLeading, endPoint: .bottomTrailing)).edgesIgnoringSafeArea(.all)

            GeometryReader { geometry in
                
                VStack {
                    
                    Divider() 
                    
                    Grid(self.viewModel.cards) { card in
                        
                        SetCard(card: card)
                            // .transition( AnyTransition.offset(randomLocationGenerator(onCanvas: geometry.size)) )
                            .transition( AnyTransition.offset(self.disgardTo) )//.animation(.easeInOut(duration: 0.75))
                            .onTapGesture {
                                withAnimation {
                                    self.viewModel.touch(viewCard: card)
                                }
                            }
                    }
                            
                            
                        
                    .frame(width: geometry.size.width, height: geometry.size.height * 0.85 )
                    
                    Spacer()
                    
                    // Bottom Menue
                    HStack {
                        
                        VStack {
                            
                            // New Game
                            Button(action: {
                                withAnimation(.easeInOut(duration: 0.75)) {
                                    self.viewModel.createNewGame()
                                }
                                
                            }) { Text("Reset Game")}
                                .foregroundColor(.primary)
                            Spacer()
                            
                            // Deal Three Cards
                            Button(action: {
                                withAnimation {
                                    self.viewModel.callModelDealThreeMoreCards()
                                }
                                
                            }) { Text("Deal 3")}
                            .foregroundColor(.primary)
                            Spacer()
                            
                            // Rearrange
                            Button(action: {
                                // withAnimation(.easeIn(duration: 0.85)) {
                                self.viewModel.rearrangeCardsForView()
                                // }
                                
                            }) { Text("Rearrange")}
                            .foregroundColor(.primary)
                            Spacer()
                            
                            // Score
                            Text("Matches: \(self.viewModel.score)/27").animation(.none)
                                .foregroundColor(.white)
                            
                        }
                        .padding()
                        Spacer()
                        
                        // Game Comments
                            Text("\(self.viewModel.gameComments)").animation(.none)
                                .font(.callout)
                                .multilineTextAlignment(.leading)
                                .foregroundColor(.white)
                    }
                }
                // .background(Color.green)
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


