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
            
            // Fill the background with a gradient.
            LinearGradient(gradient: Gradient(
                           colors: self.viewModel.theme.colorGradient
                           ),
                           startPoint: .topLeading,
                           endPoint: .bottomTrailing).edgesIgnoringSafeArea(.all)
            
            
            GeometryReader { geometry in
                
                VStack {
                    
                    topRowGuiView(viewModel: self.viewModel )
                    
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
                        .multilineTextAlignment(.center)
                        .foregroundColor(.white)
                   
                }  // VStack
                
            }   // GeometryReader
            .padding()
            
        }   // ZStack
    }   //  body
}



struct topRowGuiView: View {
    
    var viewModel: SetGameViewModel
    
    var body: some View {
    
        HStack {
            
            Text(" ") // used as a small spacer
            
            // New Game
            Button(action: {
                withAnimation(.easeInOut(duration: 0.75)) {
                    self.viewModel.createNewGame()
                }
                
            }) { Image(systemName: "arrow.counterclockwise") }
                .font(.system(size: 22.0))
            Spacer()
            
            // Change Theme
            Button(action: {
                withAnimation(.easeInOut(duration: 0.75)) {
                    self.viewModel.changeTheme()
                }
                
            }) { Image(systemName: "paintbrush") }
                .font(.system(size: 22.0))
            //.font(.headline)
            
            Spacer()
            
            // Deal Three Cards
            Button(action: {
                withAnimation {
                    self.viewModel.callModelDealThreeMoreCards()
                }
                
            }) { Image(systemName: "rectangle.stack.badge.plus") }
                .font(.system(size: 22.0))
                .foregroundColor(self.viewModel.noRemainingCards ?  .white : .white)
                .disabled(self.viewModel.noRemainingCards)
            
            Spacer()
            
            
            // Rearrange
            Button(action: {
                withAnimation(.easeIn(duration: 0.85)) {
                    self.viewModel.rearrangeCardsForView()
                }
                
            }) { Image(systemName: "shuffle") }
                .font(.system(size: 22.0))
            
            Spacer()
            
            // Rearrange
            Button(action: {
                withAnimation(.easeIn(duration: 0.85)) {
                    self.viewModel.findMatches()
                }
                
            }) { Image(systemName: "eyeglasses") }
                .font(.system(size: 22.0))
            
            
            // Score
            // Text("Sets: \(self.viewModel.score)/27").animation(.none)
            
            
        }
    .foregroundColor(.white)
        
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


