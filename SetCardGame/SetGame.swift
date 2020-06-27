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
    var dealtCards = [SetCard]()
    var discarded = [SetCard]()

    enum SetNumber: Int, CaseIterable {
        case one = 1, two = 2, three = 3
    }
    enum SetShape: String, CaseIterable {
         case diamond, squiggle, oval
    }
    enum SetColor: String, CaseIterable {
        case red, green, purple
    }
    enum SetShading: Double, CaseIterable {
        case solid = 1.0, stripped = 0.35, open = 0.02
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
    
    
    
    
    
    mutating func touchCard(_ card: SetCard ) {
        
        // select/unselect via touch until three cards selected
        if let firstIndex = dealtCards.firstIndex(where: { $0.id == card.id  }) {
            dealtCards[ firstIndex ].isSelected = !dealtCards[ firstIndex ].isSelected
            gameComments = "\(dealtCards[firstIndex].isSelected ? "Selected:" : "Deselected:") \(card.cardNumber) \(card.cardColor) \(card.cardShape) \n"
        }
        
        // build array of selected cards
        let selectedCards = dealtCards.filter { $0.isSelected }
        
        // gameComments += "\(selectedCards.count) cards selected\n"
        
        for (i, card) in selectedCards.enumerated() {
            gameComments += "Card(\(i+1)): \(card.cardNumber) \(card.cardColor) \(card.cardShape) \n"
        }
        
                
        // if three are selected ...
        if selectedCards.count == 3 {
            
            if checkCards(forSetMatch: selectedCards ) == true {
                score += 1
                // cards were a match, replace them with dealt cards from the deck
                gameComments = "FOUND A Match !!!  Excellet!\n"
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
                // cards were not a match ... unmark them as selected
                for card in selectedCards {
                    if let firstIndex = dealtCards.firstIndex(where: { $0.id == card.id  }) {
                        dealtCards[firstIndex].isSelected = !dealtCards[firstIndex].isSelected
                        
                    }
                }
            }
        }
        
        
        // gameComments += "Card\(card.id): \(card.cardNumber), \(card.cardShape) \(card.cardColor) \(card.cardShading)\n"
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
                gameComments += "two \(number.rawValue)'s\n"
                numberSettable = false
                break
            }
        }
        for color in SetColor.allCases {
            if ( cards.filter { $0.cardColor == color.rawValue }.isNotASet)  {
                gameComments += "two \(color.rawValue.uppercased())'s\n"
                colorSettable = false
                break
            }
        }
        for shape in SetShape.allCases {
            if ( cards.filter { $0.cardShape == shape.rawValue }.isNotASet)  {
                gameComments += "two \(shape.rawValue.uppercased())'s\n"
                shapeSettable = false
                break
            }
        }
        for shading in SetShading.allCases {
            if ( cards.filter { $0.cardShading == shading.rawValue }.isNotASet)  {
                gameComments += "two: \(shading.rawValue)'s\n"
                shadingSettable = false
                break
            }
        }
        return numberSettable && colorSettable && shapeSettable && shadingSettable
    }

    
    
    struct SetCard: Identifiable {
        
        // Pure Model Attributes
        let cardNumber: Int
        let cardShape: String
        let cardColor: String
        let cardShading: Double
        
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
