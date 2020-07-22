//
//  SetGameViewModel.swift
//  SetCardGame
//
//  Created by Walters on 6/25/20.
//  Copyright © 2020 Richard Walters. All rights reserved.
//

import SwiftUI

enum ViewCardShape {
    case diamond, squiggle, circle
}

enum ViewCardShading: Double {
    case filled  = 1.0
    case patterened = 0.40
    case outlined = 0.01
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


/// Set Game ViewModel.
///
/// - Publishes changes from Set game Model according to the MVVM design.
/// - Converts Set game model cards into cards tailored for views.
/// - Cordinates themes colors for game.
class SetGameViewModel: ObservableObject {
    
    @Published private var game = SetGameModel()
    
    // MARK: - user access to cards tailored for views.
    // cards are "get-only"
    var cards: [CardForView] {
        updateCardsForView()
    }
    
    // MARK: - view access to theme colors
    var theme = Theme()
    
    /// Updates View Cards from current state of Model Cards.
    ///
    /// Converts model descriptions attributes into view elements.
    private func updateCardsForView() -> [CardForView] {
        var freshCardsForView = [CardForView]()
        var time = 0.0
        for gameCard in game.dealtCards {
            time += 0.25
            if time > 3.0 { time = 0.0 }
            let viewCard = CardForView(delay: Double(gameCard.id),
                                       pips: (gameCard.cardNumber == SetGameModel.SetNumber.one.rawValue) ? 1
                                        : (gameCard.cardNumber == SetGameModel.SetNumber.two.rawValue) ? 2 : 3,
                                       
                                       shape: (gameCard.cardShape == SetGameModel.SetShape.firstShape.rawValue) ? ViewCardShape.diamond
                                        : (gameCard.cardShape == SetGameModel.SetShape.secondShape.rawValue) ? ViewCardShape.squiggle
                                        : ViewCardShape.circle,
                                       
                                       color: (gameCard.cardColor == SetGameModel.SetColor.firstColor.rawValue) ? .red
                                        : (gameCard.cardColor == SetGameModel.SetColor.secondColor.rawValue) ? .green
                                        : .purple,
                                       
                                       // translate shading from string to an opacity value of Double
                                       shading: (gameCard.cardShading == SetGameModel.SetShading.filled.rawValue) ? ViewCardShading.filled.rawValue
                                        : (gameCard.cardShading == SetGameModel.SetShading.patterened.rawValue)  ? ViewCardShading.patterened.rawValue
                                        : ViewCardShading.outlined.rawValue,
                                       
                                       isSelected: gameCard.isSelected,
                                       isOneOfThreeSelected: gameCard.isOneOfThreeSelected,
                                       isMatched: gameCard.isMatched,
                                       
                                       gameState: (gameCard.cardState == SetGameModel.CardGameState.inPlay.rawValue) ? .inPlay
                                        : (gameCard.cardState == SetGameModel.CardGameState.disgarded.rawValue) ? .matchedAndDiscarded
                                        : .undealt,
                                       
                                       id: gameCard.id )
            
            freshCardsForView.append(viewCard)
        }
        
        return freshCardsForView
    }
    
    
    
    // MARK: User Access to score in model
    var score: Int {
        game.score
    }
    
    var noRemainingCards: Bool {
        game.dealtCards.count == 0
    }
    
    var gameComments: String {
        game.gameComments
    }
    
    // MARK: - User Intent(s)
    func createNewGame() {
        theme.loadNext()
        game = SetGameModel()
    }
    
    // Separate from model,
    // objectWillChange.send() updates theme change immediately
    func changeTheme() {
        objectWillChange.send()
        theme.loadNext()
    }
    
    // translate touch(viewCard:) to
    // model's select(card: ) function ...
    func touch(viewCard: CardForView) {
        let arrayOfModelCardsThatMatchTouchedViewCardID = game.dealtCards.filter  { $0.id == viewCard.id }
        assert(arrayOfModelCardsThatMatchTouchedViewCardID.count == 1, "ERROR: viewCard doesnt coorespond to exactly one gameCard")
        game.select(card: arrayOfModelCardsThatMatchTouchedViewCardID.first!)
    }
    
    func callModelDealThreeMoreCards() {
        game.dealThreeMoreCards()
    }
    
    func findMatches() {
        game.getMatchingHint()
    }
    
    func rearrangeCardsForView() {
        game.rearrangeDealtCards()
    }
    
}
