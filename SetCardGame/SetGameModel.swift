//
//  SetGame.swift
//  SetCardGame
//
//  Created by Walters on 6/25/20.
//  Copyright © 2020 Richard Walters. All rights reserved.
//

import Foundation


/// Find Combinations for n(Cr) , or N Chose k.
///
///
func combinations<T>(itemsN: [T], chooseK : Int) -> [[T]] {
    if(itemsN.count == chooseK) {
        return [itemsN]
    }
    
    if(itemsN.isEmpty) {
        return []
    }
    
    if(chooseK == 0) {
        return []
    }
    
    if(chooseK == 1) {
        return itemsN.map { [$0] }
    }
    
    var result : [[T]] = []
    
    let rest = Array(itemsN.suffix(from: 1))
    let subCombos = combinations(itemsN: rest, chooseK: chooseK - 1)
    result += subCombos.map { [itemsN[0]] + $0 }
    result += combinations(itemsN: rest, chooseK: chooseK)
    return result
}


struct SetGameModel {
    
    private(set) var gameComments = ""
    private(set) var score = 0
    
    private var deck: [SetCard]
    private(set) var dealtCards = [SetCard]()
    private var setMatches = Set<Set<Int>>()   // a Set of Sets (SoS) of indices for Set-Matches (sorry, too much fun with this one.)
    private var cheatMatch = [SetCard]()       // one selected set matching cards, ready to go for cheat mode.

    private var disgardedCards = [SetCard]()   // TODO: this is not used, should clean up code to get rid of this.
    
    private var selectedCards: [SetCard] {
        dealtCards.filter { $0.isSelected }
    }
    
    private static var idSeedStart = 81
    
    private var threeCardsAreSelected: Bool {
        selectedCards.count == 3
    }
    
    fileprivate enum SetNumber: String, CaseIterable {
        case one, two, three
    }
    fileprivate enum SetShape: String, CaseIterable {
        case diamond, squiggle, oval
    }
    fileprivate enum SetColor: String, CaseIterable {
        case red, green, purple
    }
    fileprivate enum SetShading: String, CaseIterable {
        case solid, stripe, open
    }
    private enum CardGameState: String {
        case undealt, inPlay, disgarded
    }
    
    
    init() {
        
        gameComments = "Pick 3 with each quality all the same or all different. (2 only cannot share a quality.)"
        
        // load fresh deck
        deck = SetGameModel.freshDeckOfCards()
        
        // deal 12 cards from deck
        for index in 0..<12 {
            dealtCards.append( deck.removeFirst() )
            dealtCards[index].cardState = CardGameState.inPlay.rawValue
        }
        
    }
    
    
    private static func freshDeckOfCards() -> [SetCard] {
        var deck = [SetCard]()
        var index: Int
        
        // SetGame.idSeedStart = SetGame.idSeedStart == 0 ? 81 : 0
        
        for (indexShading, shading) in SetShading.allCases.enumerated() {
            for (indexShape, shape) in SetShape.allCases.enumerated() {
                for (indexColor, color) in SetColor.allCases.enumerated() {
                    for (indexNumber, number) in SetNumber.allCases.enumerated() {
                        index = indexShading * 27 + indexShape * 9 + indexColor * 3 + indexNumber + SetGameModel.idSeedStart
                        
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
    
    
    /// DeSelects all selected cards.
    ///
    /// Utility function
    private mutating func deselectAllSelected() {
        
        for selectedCard in selectedCards {
            if let firstIndex = dealtCards.firstIndex(where: { $0.id == selectedCard.id }) {
                dealtCards[firstIndex].isSelected = false
                dealtCards[firstIndex].isOneOfThreeSelected = false
            }
        }
        
    }
    
    /// Toggles Selected/Deselected state of a Set Card
    ///
    /// Utility function.
    private mutating func toggleSelectedAttribute(for card: SetCard) {
        if let firstIndex = dealtCards.firstIndex(where: { $0.id == card.id  }) {
            dealtCards[firstIndex].isSelected = !dealtCards[ firstIndex ].isSelected
        }
    }
    
    /// Rearranges Dealt Cards.
    ///
    /// Perhaps seeing cards in different arrangement will enable seeing set possibilities  better.
    mutating func rearrangeDealtCards() {
        dealtCards.shuffle()
    }
    
    /// Executes Set game logic when player selects a card.
    ///
    /// - allows selection/deselection for first two cards.
    /// - detects and processes _three-cards-are-selected_ game state.
    /// - parameter card: A card in _dealtCards_ array.
    mutating func select(card: SetCard ) {
        
        gameComments = ""
        
        // Process three cards already selected from last time ...
        if threeCardsAreSelected {
            
            // process a match
            if checkForMatch(with: selectedCards) {
                dealThreeMoreCards()
                // cheatMatch.removeAll() // whether user-found match, or cheat-found match, clear cheatMatch as new dealtCards state will follow.
                toggleSelectedAttribute(for: card)
                
            } else {  // process a non-match
                gameComments = ""
                deselectAllSelected()
                toggleSelectedAttribute(for: card)
            }
            
            // whether match or not, RETURN ...
            return
        }
        
        // toggle this card as selected/deSelected ...
        toggleSelectedAttribute(for: card)
        
        
        // print game comments for all selected cards
        for card in selectedCards {
            gameComments += "\(card.cardNumber.capitalized)-\(card.cardColor.capitalized)-\(card.cardShape.capitalized)-\(card.cardShading.capitalized) \n"
        }
        
        // if three are NOW selected (with the selection of THIS card ) ...
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
                
                // gameComments += "Try Again ..."
            }
        }
        
    }
    
    
    
    mutating func dealThreeMoreCards() {
        
        // if three more cards ...
        // setMatches info is old, update this
        if deck.count >= 3 {
            cheatMatch.removeAll()
            setMatches.removeAll()
        }
        
        // if match is showing when this function is called ...
        if threeCardsAreSelected, checkForMatch(with: selectedCards) {
            
            // and three cards are available from the main deck
            if deck.count >= 3 {
                for selectedCard in selectedCards {
                    if let selectedIndex = dealtCards.firstIndex(where: { $0.id == selectedCard.id  }) {
                        
                        // now REPLACE this card with one from the fresh deck ...
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
        gameComments = "Undealt: \(deck.count)  In Play: \(dealtCards.count)  Sets: \(score)/27"
    }
    
    
    /// Check selected cards for a _"Set-match"_.
    ///
    /// Methodology: Assume a valid set and fail if
    /// two, and only two, of a given attribute is detected.
    /// - parameter cards: An array of 3 user-selected cards.
    private mutating func checkForMatch(with cards: [SetCard] ) -> Bool {
        
        assert( cards.count == 3, "This is not a proper number of cards to check Set match!")
        
        gameComments = ""
        var numberSettable = true
        var colorSettable = true
        var shapeSettable = true
        var shadingSettable = true
        
        // For each SetNumber variation, check for "two, and only two"
        // cards with that variation.
        // If failure detected, set match as false, and break out of
        // additional checks for this attribute and update gameComments.
        //
        // Same for other attributes below.
        for number in SetNumber.allCases {
            if ( cards.filter { $0.cardNumber == number.rawValue }.isNotASet) {
                gameComments += "  two \(number.rawValue.uppercased())S "
                numberSettable = false
                break
            }
        }
        for color in SetColor.allCases {
            if ( cards.filter { $0.cardColor == color.rawValue }.isNotASet)  {
                gameComments += "  two \(color.rawValue.uppercased())S "
                colorSettable = false
                break
            }
        }
        for shape in SetShape.allCases {
            if ( cards.filter { $0.cardShape == shape.rawValue }.isNotASet)  {
                gameComments += "  two \(shape.rawValue.uppercased())S "
                shapeSettable = false
                break
            }
        }
        for shading in SetShading.allCases {
            if ( cards.filter { $0.cardShading == shading.rawValue }.isNotASet)  {
                gameComments += "  two: \(shading.rawValue.uppercased())S "
                shadingSettable = false
                break
            }
        }
        
        if !(numberSettable && colorSettable && shapeSettable && shadingSettable) {
            gameComments = "Try Again: \(gameComments)"
        }
        
        return numberSettable && colorSettable && shapeSettable && shadingSettable
    }
    
    
    
    
    /// If Cheating, deselect user-selected cards.
    ///
    /// Helper function
    private mutating func unselectCardsNotInCheatMatch() {
        assert( cheatMatch.count == 3, "Cheat match does not seem to be loaded with any indicies" )
        
        for card in selectedCards {
            if !cheatMatch.contains(where: { $0.id == card.id }) {
                let cardIndex = dealtCards.firstIndex { $0.id == card.id }
                dealtCards[cardIndex!].isSelected = false
            }
        }
        
    }
    
    
    /// Computes Index of Card that completes a Set Match.
    ///
    ///  Helpter function to find the third matching card index of a card pair comnination.
    /// - Parameter firstTwoCards: an array that holds two Set cards.
    private func matchingCardIndex(for firstTwoCards: [SetCard], in cardDeck: [SetCard]) -> Int? {
        guard let first = cardDeck.firstIndex(where: {
            $0.cardNumber == firstTwoCards.missingSetNumber() &&
            $0.cardShape == firstTwoCards.missingSetShape() &&
            $0.cardColor == firstTwoCards.missingSetColor() &&
            $0.cardShading == firstTwoCards.missingSetFill()    })  else { return nil }
        return first
    }
    
    
    /// Searches DealtCards for a Match.
    ///
    /// This function provides _incremental hints._
    /// - First call will print available Set matches in dealt cards, and load a random Matching Set into global cheatMatch array
    /// - If **cheatMatch** has not been cleared elsewhere, second call will select  the first card of the match for the user.
    /// - if **cheatMatch** has not been cleared elsewhere, third call will select the second card of the match for the user.
    /// - if **cheatmatch** has not been cleared elsewhere, fourth call will select the third card of the match for the user.
    ///
    /// processing a match in selectCard(_ card: SetCard) will clear cheatMatch array and restart incremental processing.
    mutating func getMatchingHint() {
        
        if threeCardsAreSelected {
            gameComments = "Tap any Card to Continue ..."
            return
        }
        
        // check if existing cheatMatch is currently good.
        if cheatMatch.count == 3 && checkForMatch(with: cheatMatch ) {
            
            
            // select cheat card match one card per turn
            for card in cheatMatch {
                
                // first, unselect any user-selected cards,
                // that are not in the cheat match.
                unselectCardsNotInCheatMatch()
                
                
                let index = dealtCards.firstIndex( where: { $0.cardNumber == card.cardNumber &&
                                $0.cardColor == card.cardColor &&
                                $0.cardShape == card.cardShape &&
                                $0.cardShading == card.cardShading } )
                
                // only select the first non-selected card, then exit the function
                // let select(card: Setcard) handle normal processing details.
                if dealtCards[index!].isSelected == false {
                    select(card: card )
                    return
                }
            }
            
        } else { // find a new cheat matches.
                    
            let twoCardCombinations = combinations(itemsN: dealtCards, chooseK: 2)
            var tempMatch = Set<Int>()
            setMatches.removeAll()
            cheatMatch.removeAll()
            
            for cardPair in twoCardCombinations {
                if let lastMatchingCardIndex = matchingCardIndex(for: cardPair, in: dealtCards) {
                    
                    let first = dealtCards.firstIndex( where: { $0.cardNumber == cardPair[0].cardNumber && $0.cardColor == cardPair[0].cardColor && $0.cardShape == cardPair[0].cardShape && $0.cardShading == cardPair[0].cardShading } )
                    
                    let second = dealtCards.firstIndex( where: { $0.cardNumber == cardPair[1].cardNumber && $0.cardColor == cardPair[1].cardColor && $0.cardShape == cardPair[1].cardShape && $0.cardShading == cardPair[1].cardShading } )

                    let third = lastMatchingCardIndex
                    
                    tempMatch = [ first!, second!, third ]
                    setMatches.insert( tempMatch )
                }
            }
            
            if let setMatch = setMatches.randomElement() {
                for index in setMatch {
                    cheatMatch.append(dealtCards[index])
                }
            }
        }
                
        switch setMatches.count {
        case 0: gameComments = "There are no sets in the dealt cards above; deal three more cards."
        case 1: gameComments = "There is only \(setMatches.count) set in the dealt cards above."
        default: gameComments = "There are \(setMatches.count) sets in the dealt cards above."
        }
        
        gameComments += "Tap eyeglasses for additional help."
        

    }
    
    
    struct SetCard: Identifiable  {
        
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


// Extensions for Array used for Set Card Game Model


/// Returns True if size of array is two.
///
/// **isNotASet** may be used after filtering an array for a card attribute
extension Array {
    var isNotASet: Bool {
        self.count == 2 ? true : false
    }
}


/// Given two cards, extended Array function to calculate third card's necessary attribute.
///
/// May be used in session as:
/// guard let indexOfMatching = cardDeck.firstIndex(where: {
///       $0.cardNumber == firstTwoCards.missingSetNumber() &&
///       $0.cardShape == firstTwoCards.missingSetShape() &&
///       $0.cardColor == firstTwoCards.missingSetColor() &&
///       $0.cardShading == firstTwoCards.missingSetFill()    })  else { return nil }
extension Array where Element == SetGameModel.SetCard {
    
    func missingSetShape() -> String? {
        var shapeCount: Int
        var possibleShape: String?
        assert(self.count == 2, "Expected Array size of 2, received array of size \(self.count) ")
        for shape in SetGameModel.SetShape.allCases {
            shapeCount = self.filter { $0.cardShape == shape.rawValue }.count
            if shapeCount == self.count { return shape.rawValue }
            if shapeCount == 0 { possibleShape = shape.rawValue}
        }
        return possibleShape
    }
    
    func missingSetNumber() -> String? {
        var numberCount: Int
        var possibleNumber: String?
        assert(self.count == 2, "Expected Array size of 2, received array of size \(self.count) ")
        for number in SetGameModel.SetNumber.allCases {
            numberCount = self.filter { $0.cardNumber == number.rawValue }.count
            if numberCount == self.count { return number.rawValue }
            if numberCount == 0 { possibleNumber = number.rawValue}
        }
        return possibleNumber
    }
    
    func missingSetColor() -> String? {
        var colorCount: Int
        var possibleColor: String?
        assert(self.count == 2, "Expected Array size of 2, received array of size \(self.count) ")
        for color in SetGameModel.SetColor.allCases {
            colorCount = self.filter { $0.cardColor == color.rawValue }.count
            if colorCount == self.count { return color.rawValue }
            if colorCount == 0 { possibleColor = color.rawValue}
        }
        return possibleColor
    }
    
    func missingSetFill() -> String? {
        var shadingCount: Int
        var possibleShading: String?
        assert(self.count == 2, "Expected Array size of 2, received array of size \(self.count) ")
        for shading in SetGameModel.SetShading.allCases {
            shadingCount = self.filter { $0.cardShading == shading.rawValue }.count
            if shadingCount == self.count { return shading.rawValue }
            if shadingCount == 0 { possibleShading = shading.rawValue}
        }
        return possibleShading
    }
}
