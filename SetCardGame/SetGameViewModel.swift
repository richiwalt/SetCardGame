//
//  SetGameViewModel.swift
//  SetCardGame
//
//  Created by Walters on 6/25/20.
//  Copyright © 2020 Richard Walters. All rights reserved.
//

import SwiftUI

enum SetCardShape {
    case circle, diamond, squiggle
}

struct cardForView: Identifiable {
    var pips: Int
    var shape: SetCardShape
    var color: Color
    var shading: Double
    var isSelected: Bool
    var id: Int
}

class SetGameViewModel: ObservableObject {
    
    @Published private var game = SetGame()
    
    // MARK: - present view cards based on model cards
    var cards: [cardForView] {
        updateCardsForView()
    }
    
    
    
    func updateCardsForView() -> [cardForView] {
        var freshCardsForView = [cardForView]()
        for card in game.dealtCards {
            let card = cardForView(pips: card.cardNumber == "one" ? 1 : card.cardNumber == "two" ? 2 : 3,
                                   shape: card.cardShape == "squiggle" ? SetCardShape.squiggle : card.cardShape == "diamond" ? SetCardShape.diamond : SetCardShape.circle,
                                   color: card.cardColor == "red" ? .red : card.cardColor == "green" ? .green : .purple,
                                   shading: card.cardShading == "solid" ? 1.0 : card.cardShading == "open" ? 0.01 : 0.35,
                                   isSelected: card.isSelected,
                                   id: card.id
            )
            freshCardsForView.append(card)
        }
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
    
    func touch(viewCard: cardForView) {
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
