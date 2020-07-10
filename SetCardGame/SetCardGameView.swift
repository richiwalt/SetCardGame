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
    
    var body: some View {
        
        ZStack {
            
            (LinearGradient(gradient: Gradient(colors: [.yellow, .orange, .red, .purple]), startPoint: .topLeading, endPoint: .bottomTrailing)).edgesIgnoringSafeArea(.all)

            GeometryReader { geometry in
                
                VStack {
                    
                    Grid(self.viewModel.cards) { card in
                        
                        SetCardView(card: card)
                
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


struct SetCardView: View {
    
    let card: CardForView
    var dealFrom: CGSize = CGSize(width: Double.random(in: -1000...(-100)), height: Double.random(in: -800...(-100)) )
    var disgardTo: CGSize = CGSize(width: Double.random(in: 100...(1000)), height: Double.random(in: -800...(-100)) )
    @State private var isVisible: Bool = false
    
    var body: some View {
        ZStack {
                        
            if isVisible && card.gameState.rawValue == "inPlay" {
                
                Group {
                    RoundedRectangle(cornerRadius: 10).fill(Color.white).opacity(card.isSelected ? 1.0 : 1.0 )
                        .shadow(color: .black, radius: 10, x: 10, y: 13)
                    
                    RoundedRectangle(cornerRadius: 10).stroke(lineWidth: card.isSelected ? 1.0 : 1.3).foregroundColor(.accentColor)
                        //.shadow(color: .black, radius: 1, x: 2, y: 2)
                }
                .scaleEffect(self.card.isSelected ? 0.60 : 1.0 )//.animation(.easeInOut(duration: 0.65))
                .transition(.offset(self.dealFrom))// .animation(Animation.easeOut.delay(  card.delay   ))
                
                
                
                VStack {
                    
                    ForEach( 0..<card.pips ) { _ in
                        
                        ZStack {
                            getShape(self.card.shape).opacity(self.card.shading).shadow(color: .black, radius: 1, x: 1.5, y: 1.5)
                            
                            getShape(self.card.shape)
                                .stroke(lineWidth: 2)
                                .opacity(self.card.shading < 0.1 ? 1.0 : 0.0)
                        }
                        .rotation3DEffect(Angle.degrees(self.card.isMatched ? 360 : 0 ), axis: (0,1,0))
                        .animation(self.card.isMatched ? Animation.linear(duration: 0.6).repeatForever(autoreverses: false) : .default )
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
            withAnimation(.easeInOut(duration: 1)) {
                self.isVisible = true
            }
        }
        .onDisappear() {
            withAnimation(.easeInOut(duration: 1)) {
                self.isVisible = true
            }
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


