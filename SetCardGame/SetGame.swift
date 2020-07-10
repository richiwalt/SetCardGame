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
    var score = 0
    
    var deck: [SetCard]
    var dealtCards = [SetCard]()
    var disgardedCards = [SetCard]()
    
    var selectedCards: [SetCard] {
        dealtCards.filter { $0.isSelected }
    }
    
    var threeCardsAreSelected: Bool {
        selectedCards.count == 3
    }
    
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
        case solid, stripe, open
    }
    enum CardGameState: String {
        case undealt, inPlay, disgarded
    }
    
    
    init() {
        
        gameComments = "Choose 3 Cards. All attributes must all be the same, or else all different. (I.e. a given attribute cannot exists for only two cards!)"
        
        // load fresh deck
        deck = SetGame.freshDeckOfCards()
        
        // deal 12 cards from deck
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
        
        for selectedCard in selectedCards {
            if let firstIndex = dealtCards.firstIndex(where: { $0.id == selectedCard.id }) {
                dealtCards[firstIndex].isSelected = false
                dealtCards[firstIndex].isOneOfThreeSelected = false
            }
        }
        
    }
    
    
    mutating func toggleSelectedAttribute(for card: SetCard) {
        if let firstIndex = dealtCards.firstIndex(where: { $0.id == card.id  }) {
            dealtCards[firstIndex].isSelected = !dealtCards[ firstIndex ].isSelected
        }
    }
    
    
    
    ///
    /// The Heart of Game Logic
    ///   ... perform actions when a card is selected
    ///
    mutating func select(card: SetCard ) {
        
        gameComments = ""
        
        // Process three cards already selected from last time ...
        if threeCardsAreSelected {
            
            // for match
            if checkForMatch(with: selectedCards) {
                dealThreeMoreCards()
                toggleSelectedAttribute(for: card)
                
            } else {  // process a non-match
                gameComments = ""
                deselectAllSelected()
                toggleSelectedAttribute(for: card)
            }
            return
        }
                        
        // toggle this card as selected/deSelected ...
        toggleSelectedAttribute(for: card)
        
        
        // print game comments of selected cards
        for card in selectedCards {
            gameComments += "\(card.cardNumber.capitalized)-\(card.cardColor.capitalized)-\(card.cardShape.capitalized)-\(card.cardShading.capitalized) \n"
        }
        
        // if three are NOW selected with this card ...
        if threeCardsAreSelected {
            
            // first update Card's isOneOfThreeSelected attribute ..
            for card in selectedCards {
                if let firstIndex = dealtCards.firstIndex(where: { $0.id == card.id  }) {
                    dealtCards[firstIndex].isOneOfThreeSelected = true
                }
            }
            
            // process for match
            if checkForMatch(with: selectedCards ) == true {
                gameComments = "😃😃😃😃😃😃😃😃"
                score += 1
                
                // first mark these three cards as a matched ...
                for card in selectedCards {
                    if let firstIndex = dealtCards.firstIndex(where: { $0.id == card.id  }) {
                        dealtCards[firstIndex].isMatched = !dealtCards[firstIndex].isMatched
                    }
                }
                
                
            } else { // process for non-match  ...
                
                for card in selectedCards {
                    if let firstIndex = dealtCards.firstIndex(where: { $0.id == card.id  }) {
                        dealtCards[firstIndex].isMatched = false
                    }
                }

                gameComments += "Try Again ..."
            }
        }
        
    }
    
    
    
    mutating func dealThreeMoreCards() {
        
        // if match is showing when this function is called ... 
        if threeCardsAreSelected, checkForMatch(with: selectedCards) {
            
            // and three cards are available from the main deck
            if deck.count >= 3 {
                for selectedCard in selectedCards {
                    if let selectedIndex = dealtCards.firstIndex(where: { $0.id == selectedCard.id  }) {
                        dealtCards[selectedIndex].cardState = CardGameState.disgarded.rawValue
                        dealtCards[selectedIndex] = deck.removeFirst()
                        dealtCards[selectedIndex].cardState = CardGameState.inPlay.rawValue
                    }
                }
                
            } else {
                // no more cards in deck ... just remove these matched cards ...
                for card in selectedCards {
                    if let firstIndex = dealtCards.firstIndex(where: { $0.id == card.id  }) {
                        dealtCards.remove(at: firstIndex)
                    }
                }
            }
            
        
        } else if deck.count >= 3 {
            // no match was showing when this funtion was called ...
            // just add three more cards to dealt cards on table
            for _ in 0..<3 {
                deck[0].cardState = CardGameState.inPlay.rawValue
                dealtCards.append( deck.removeFirst() )
            }
        }
        gameComments = "\(deck.count) remaining; \(dealtCards.count) in play; \(disgardedCards.count)/27 matches"
    }
    
    
    
    mutating func checkForMatch(with cards: [SetCard] ) -> Bool {
        gameComments = ""
        var numberSettable = true
        var colorSettable = true
        var shapeSettable = true
        var shadingSettable = true
        for number in SetNumber.allCases {
            if ( cards.filter { $0.cardNumber == number.rawValue }.isNotASet) {
                gameComments += "  two \(number.rawValue.uppercased())S\n"
                numberSettable = false
                break
            }
        }
        for color in SetColor.allCases {
            if ( cards.filter { $0.cardColor == color.rawValue }.isNotASet)  {
                gameComments += "  two \(color.rawValue.uppercased())S\n"
                colorSettable = false
                break
            }
        }
        for shape in SetShape.allCases {
            if ( cards.filter { $0.cardShape == shape.rawValue }.isNotASet)  {
                gameComments += "  two \(shape.rawValue.uppercased())S\n"
                shapeSettable = false
                break
            }
        }
        for shading in SetShading.allCases {
            if ( cards.filter { $0.cardShading == shading.rawValue }.isNotASet)  {
                gameComments += "  two: \(shading.rawValue.uppercased())S\n"
                shadingSettable = false
                break
            }
        }
        
        if !(numberSettable && colorSettable && shapeSettable && shadingSettable) {
            gameComments = "Not a Match:\n\(gameComments)"
        }
        
        return numberSettable && colorSettable && shapeSettable && shadingSettable
    }
    
    struct SetCard: Identifiable {
        
        // Pure Game Attributes
        let cardNumber: String
        let cardShape: String
        let cardColor: String
        let cardShading: String
        
        // Playing Attributes
        var cardState: String
        var isSelected = false
        var isOneOfThreeSelected = false
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
