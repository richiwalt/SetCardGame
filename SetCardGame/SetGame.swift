//
//  SetGame.swift
//  SetCardGame
//
//  Created by Walters on 6/25/20.
//  Copyright © 2020 Richard Walters. All rights reserved.
//

import Foundation



struct SetGame {
    
    var gameComments = ""
    var score: Int = 0
    var deck: [SetCard]
    static var tryAgain: Bool = false
    var dealtCards = [SetCard]()
    var discarded = [SetCard]()  // TODO: may not even need this
    
    enum SetNumber: String, CaseIterable {
        case one, two, three
    }
    enum SetShape: String, CaseIterable {
        case diamond, squiggle, oval
    }
    enum SetColor: String, CaseIterable {
        case red, green, purple
    }
    enum SetShading: String, CaseIterable {
        case solid, stripped, open
    }
    enum CardGameState: String {
        case undealt, inPlay, matchedAndDiscarded
    }
    
    init() {
        // get fresh deck of cards
        deck = SetGame.freshDeckOfCards()
        
        // deal cards
        for index in 0..<12 {
            dealtCards.append( deck.removeFirst() )
            dealtCards[index].cardState = CardGameState.inPlay.rawValue
        }
    }
    
    static func freshDeckOfCards() -> [SetCard] {
        var deck = [SetCard]()
        var index: Int
        
        for (indexShading, shading) in SetShading.allCases.enumerated() {
            for (indexShape, shape) in SetShape.allCases.enumerated() {
                for (indexColor, color) in SetColor.allCases.enumerated() {
                    for (indexNumber, number) in SetNumber.allCases.enumerated() {
                        index = indexShading * 27 + indexShape * 9 + indexColor * 3 + indexNumber
                        
                        deck.append(SetCard(cardNumber: number.rawValue,
                                            cardShape: shape.rawValue,
                                            cardColor: color.rawValue,
                                            cardShading: shading.rawValue,
                                            cardState: CardGameState.undealt.rawValue,
                                            id: index))
                        
                    }
                }
            }
        }
        deck.shuffle()
        deck.shuffle()
        return deck
    }
    
    
    mutating func rearrangeDealtCards() {
        dealtCards.shuffle()
    }
    
    
    // Utility Function to Deselect all Selected Gards ...
    // Called when SetGame.tryAgain is true
    mutating func deselectAllSelected() {
        let selectedCards = dealtCards.filter { $0.isSelected }
        for selected in selectedCards {
            if let index = dealtCards.firstIndex(where: { $0.id == selected.id }) {
                dealtCards[index].isSelected = !dealtCards[index].isSelected
            }
        }
        SetGame.tryAgain = false
    }
    
    
    // The Heart of Game Logic ... perform actions when a card is selected
    mutating func select(card: SetCard ) {
        
        // Start Fresh if SetGame.tryAgain is true
        if SetGame.tryAgain == true {
            deselectAllSelected()
        }
        
        gameComments = ""
        
        // select/unselect via touch until three cards selected
        if let firstIndex = dealtCards.firstIndex(where: { $0.id == card.id  }) {
            dealtCards[ firstIndex ].isSelected = !dealtCards[ firstIndex ].isSelected
            // print statement below for debugging only ...
            // gameComments = "\(dealtCards[firstIndex].isSelected ? "Selected:" : "Deselected:") \(card.cardNumber.capitalized)-\(card.cardColor.capitalized)-\(card.cardShape.capitalized)-\(card.cardShading.capitalized)\n\n"
        }
        
        // build array of selected cards
        let selectedCards = dealtCards.filter { $0.isSelected }
        
        for (i, card) in selectedCards.enumerated() {
            gameComments += "Card(\(i+1)): \(card.cardNumber.capitalized)-\(card.cardColor.capitalized)-\(card.cardShape.capitalized)-\(card.cardShading.capitalized) \n"
        }
        
        // if three are selected ...
        if selectedCards.count == 3 {
            
            if checkCards(forSetMatch: selectedCards ) == true {
                gameComments = "FOUND A Match !!!  Excellent!   \n"
                score += 1
                
                // cards were a match, replace them with dealt cards from the deck if available
                if deck.count >= 3 {
                    for card in selectedCards {
                        if let firstIndex = dealtCards.firstIndex(where: { $0.id == card.id  }) {
                            // need to transfer matched cards into discarded cards ...
                            dealtCards[firstIndex].isSelected = !dealtCards[firstIndex].isSelected
                            dealtCards[firstIndex] = deck.removeFirst() // TODO: check there is a first card
                            dealtCards[firstIndex].cardState = CardGameState.inPlay.rawValue
                        }
                        // double check that deck.count + dealtCards.count + discarded.count == 81
                    }
                    
                } else {
                    // no more cards in deck ... just remove these matched cards ...
                    for card in selectedCards {
                        if let firstIndex = dealtCards.firstIndex(where: { $0.id == card.id  }) {
                            dealtCards[firstIndex].isSelected = !dealtCards[firstIndex].isSelected
                            dealtCards.remove(at: firstIndex)
                        }
                    }
                }
                
            } else {
                // cards were not a match ...
                
            }
        }
    }
    
    mutating func dealThreeMoreCards() {
        if deck.count >= 3 {
            for index in 0..<3 {
                dealtCards.append( deck.removeFirst() )
                dealtCards[index].cardState = CardGameState.inPlay.rawValue
            }
        }
        gameComments = "\(deck.count) remaining; \(dealtCards.count) in play; \(discarded.count)/27 matches"
    }
    
    mutating func checkCards(forSetMatch cards: [SetCard] ) -> Bool {
        gameComments = ""
        var numberSettable = true
        var colorSettable = true
        var shapeSettable = true
        var shadingSettable = true
        for number in SetNumber.allCases {
            if ( cards.filter { $0.cardNumber == number.rawValue }.isNotASet) {
                gameComments += "two \(number.rawValue.uppercased())'s; "
                numberSettable = false
                break
            }
        }
        for color in SetColor.allCases {
            if ( cards.filter { $0.cardColor == color.rawValue }.isNotASet)  {
                gameComments += "two \(color.rawValue.uppercased())'s; "
                colorSettable = false
                break
            }
        }
        for shape in SetShape.allCases {
            if ( cards.filter { $0.cardShape == shape.rawValue }.isNotASet)  {
                gameComments += "two \(shape.rawValue.uppercased())'s; "
                shapeSettable = false
                break
            }
        }
        for shading in SetShading.allCases {
            if ( cards.filter { $0.cardShading == shading.rawValue }.isNotASet)  {
                gameComments += "two: \(shading.rawValue.uppercased())'s; "
                shadingSettable = false
                break
            }
        }
        
        if !(numberSettable && colorSettable && shapeSettable && shadingSettable) {
            SetGame.tryAgain = true
            gameComments = "Not a Match:\n  \(gameComments)\n"
        }
        
        return numberSettable && colorSettable && shapeSettable && shadingSettable
    }
    
    struct SetCard: Identifiable {
        
        // Pure Model Attributes
        let cardNumber: String
        let cardShape: String
        let cardColor: String
        let cardShading: String
        
        // Playing Attributes
        var cardState: String
        var isSelected = false
        var isMatched = false
        
        // iOS Attributes
        let id: Int
    }
    
}


extension Array {
    var isNotASet: Bool {
        self.count == 2 ? true : false
    }
}
