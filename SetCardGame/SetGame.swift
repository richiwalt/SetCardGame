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
    var cards = SetGame.generateSetCardDeck()

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
        case solid = 1.0, stripped = 0.35, open = 0.0
    }
    
    
    static func generateSetCardDeck() -> [SetCard] {
        var deck = [SetCard]()
        var index: Int

        for (indexShading, shading) in SetShading.allCases.enumerated() {
            for (indexShape, shape) in SetShape.allCases.enumerated() {
                for (indexColor, color) in SetColor.allCases.enumerated() {
                    for (indexNumber, number) in SetNumber.allCases.enumerated() {
                        index = indexShading * 27 + indexShape * 9 + indexColor * 3 + indexNumber + 1
                        
                        deck.append(SetCard(cardNumber: number.rawValue,
                                            cardShape: shape.rawValue,
                                            cardColor: color.rawValue,
                                            cardShading: shading.rawValue,
                                            id: index))
                        
                    }
                }
            }
        }

        deck.shuffle()
        deck.shuffle()
        return deck
    }


    mutating func checkSettable(_ cards: [SetCard] ) -> Bool {
        gameComments = ""
        var numberSettable = true
        var colorSettable = true
        var shapeSettable = true
        var shadingSettable = true
        for number in SetNumber.allCases {
            if ( cards.filter { $0.cardNumber == number.rawValue }.isNotASet) {
                gameComments += "fails settable: exactly two: \(number.rawValue)"
                numberSettable = false
                break
            }
        }
        for color in SetColor.allCases {
            if ( cards.filter { $0.cardColor == color.rawValue }.isNotASet)  {
                gameComments += "fails settable: exactly two: \(color.rawValue.uppercased())"
                colorSettable = false
                break
            }
        }
        for shape in SetShape.allCases {
            if ( cards.filter { $0.cardShape == shape.rawValue }.isNotASet)  {
                gameComments += "fails settable: exactly two: \(shape.rawValue.uppercased())"
                shapeSettable = false
                break
            }
        }
        for shading in SetShading.allCases {
            if ( cards.filter { $0.cardShading == shading.rawValue }.isNotASet)  {
                gameComments += "fails settable: exactly two: \(shading.rawValue)"
                shadingSettable = false
                break
            }
        }
        return numberSettable && colorSettable && shapeSettable && shadingSettable
    }

    
    
    struct SetCard: Identifiable {
        let cardNumber: Int
        let cardShape: String
        let cardColor: String
        let cardShading: Double
        var isSelected = false
        var isOnTable = false
        let id: Int
    }
    
    
}


extension Array {
    var isNotASet: Bool {
        self.count == 2 ? true : false
    }
}
