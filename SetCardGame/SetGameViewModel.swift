//
//  SetGameViewModel.swift
//  SetCardGame
//
//  Created by Walters on 6/25/20.
//  Copyright © 2020 Richard Walters. All rights reserved.
//

import SwiftUI

enum ViewCardShape {
    case circle, diamond, squiggle
}

enum ViewCardShading: Double {
    case solid  = 1.0
    case striped = 0.40
    case open = 0.01
}

enum ViewCardGameState: String {
    case undealt, inPlay, matchedAndDiscarded
}

struct CardForView: Identifiable {
    var delay: Double
    var pips: Int
    var shape: ViewCardShape
    var color: Color
    var shading: Double
    var isSelected: Bool
    var isOneOfThreeSelected: Bool
    var isMatched: Bool
    var gameState: ViewCardGameState
    var id: Int
}

class SetGameViewModel: ObservableObject {
    
    @Published private var game = SetGame()
    
    // MARK: - present view cards based on model cards
    var cards: [CardForView] {
        updateCardsForView()
    }
    
    func updateCardsForView() -> [CardForView] {
        var freshCardsForView = [CardForView]()
        var time = 0.0
        for gameCard in game.dealtCards {
            time += 0.25
            if time > 3.0 { time = 0.0 }
            let viewCard = CardForView(delay: Double(gameCard.id),
                                   pips: gameCard.cardNumber == "one" ? 1 : gameCard.cardNumber == "two" ? 2 : 3,
                                   
                                   shape: gameCard.cardShape == "squiggle" ? ViewCardShape.squiggle
                                    : gameCard.cardShape == "diamond" ? ViewCardShape.diamond
                                    : ViewCardShape.circle,
                                   
                                   color: gameCard.cardColor == "red" ? .red
                                    : gameCard.cardColor == "green" ? .green
                                    : .purple,
                                   
                                   shading: gameCard.cardShading == "solid" ? ViewCardShading.solid.rawValue
                                    : gameCard.cardShading == "open"  ? ViewCardShading.open.rawValue
                                    : ViewCardShading.striped.rawValue,
                                   
                                   isSelected: gameCard.isSelected,
                                   isOneOfThreeSelected: gameCard.isOneOfThreeSelected,
                                   isMatched: gameCard.isMatched,
                                   
                                   gameState: gameCard.cardState == "inPlay" ? .inPlay
                                            : gameCard.cardState == "discarded" ? .matchedAndDiscarded
                                            : .undealt,
                                   
                                   id: gameCard.id )
            
            freshCardsForView.append(viewCard)
        }
        
        /*
        
        // to keep the grid from changing size, we always grab three more, but hidden cards, for the stack
        for index in 0..<2 {
            
            time += 0.25
            if time > 3.0 { time = 0.0 }
            
            let gameCard = game.deck[index]
            
            let viewCard = CardForView(delay: Double(gameCard.id),
                                   pips: gameCard.cardNumber == "one" ? 1 : gameCard.cardNumber == "two" ? 2 : 3,
                                   
                                   shape: gameCard.cardShape == "squiggle" ? ViewCardShape.squiggle
                                    : gameCard.cardShape == "diamond" ? ViewCardShape.diamond
                                    : ViewCardShape.circle,
                                   
                                   color: gameCard.cardColor == "red" ? .red
                                    : gameCard.cardColor == "green" ? .green
                                    : .purple,
                                   
                                   shading: gameCard.cardShading == "solid" ? ViewCardShading.solid.rawValue
                                    : gameCard.cardShading == "open"  ? ViewCardShading.open.rawValue
                                    : ViewCardShading.striped.rawValue,
                                   
                                   isSelected: gameCard.isSelected,
                                   isOneOfThreeSelected: gameCard.isOneOfThreeSelected,
                                   isMatched: gameCard.isMatched,
                                   
                                   gameState: gameCard.cardState == "inPlay" ? .inPlay
                                            : gameCard.cardState == "discarded" ? .matchedAndDiscarded
                                            : .undealt,
                                   
                                   id: gameCard.id )
            
            freshCardsForView.append(viewCard)
        
        }
         */
 
        return freshCardsForView
    }
    
 
    
    // MARK: User Access
    var score: Int {
        game.score
    }
    
    var gameComments: String {
        game.gameComments
    }
    
    // MARK: - User Intent(s)
    func createNewGame() {
        game = SetGame()
    }
    
    func touch(viewCard: CardForView) {
        let gameCardMatches = game.dealtCards.filter  { $0.id == viewCard.id }
        assert(gameCardMatches.count == 1, "ERROR: viewCard doesnt coorespond to gameCard")
        game.select(card: gameCardMatches.first!)
    }
    
    func callModelDealThreeMoreCards() {
        game.dealThreeMoreCards()
    }
    
    func rearrangeCardsForView() {
        game.rearrangeDealtCards()
    }
}
