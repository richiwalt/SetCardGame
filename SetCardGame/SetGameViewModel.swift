//
//  SetGameViewModel.swift
//  SetCardGame
//
//  Created by Walters on 6/25/20.
//  Copyright © 2020 Richard Walters. All rights reserved.
//

import SwiftUI


class SetGameViewModel: ObservableObject {
    
    @Published private var game = SetGame()
    
    
    // MARK: - Access to the Model
    var cards: [SetGame.SetCard] {
        game.cards
    }
    
}
