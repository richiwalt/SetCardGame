//
//  Theme.swift
//  SetCardGame
//
//  Created by Walters on 7/13/20.
//  Copyright © 2020 Richard Walters. All rights reserved.
//

import SwiftUI


struct Theme {
    
    // struct Theme itself is in control of setting colorGradient var for users.
    private(set) var colorGradient: [Color] = Theme.colorGradients.values.randomElement()!
    
    // theme ColorGradients
    static let colorGradients: [ String:[Color] ] = [
        "yellowOrangeRedPurple" : [Color.yellow, Color.orange, Color.red, Color.purple],
        "greenFeltTable" : [ Color( #colorLiteral(red: 0.09019607843137255, green: 0.13333333333333333, blue: 0.0392156862745098, alpha: 1.0) ), Color( #colorLiteral(red: 0.12941176470588237, green: 0.21568627450980393, blue: 0.06666666666666667, alpha: 1.0) ), Color( #colorLiteral(red: 0.19607843137254902, green: 0.3411764705882353, blue: 0.10196078431372549, alpha: 1.0) ), Color( #colorLiteral(red: 0.27450980392156865, green: 0.48627450980392156, blue: 0.1411764705882353, alpha: 1.0) )],
        "purples":  [ Color( #colorLiteral(red: 0.12156862745098039, green: 0.011764705882352941, blue: 0.4235294117647059, alpha: 1.0) ), Color( #colorLiteral(red: 0.17647058823529413, green: 0.011764705882352941, blue: 0.5607843137254902, alpha: 1.0) ), Color( #colorLiteral(red: 0.2196078431372549, green: 0.00784313725490196, blue: 0.8549019607843137, alpha: 1.0) ), Color( #colorLiteral(red: 0.36470588235294116, green: 0.06666666666666667, blue: 0.9686274509803922, alpha: 1.0) )],
        "blues":  [ Color( #colorLiteral(red: 0.2196078431372549, green: 0.00784313725490196, blue: 0.8549019607843137, alpha: 1.0) ), Color( #colorLiteral(red: 0.17647058823529413, green: 0.4980392156862745, blue: 0.7568627450980392, alpha: 1.0) ), Color( #colorLiteral(red: 0.23921568627450981, green: 0.6745098039215687, blue: 0.9686274509803922, alpha: 1.0) ), Color( #colorLiteral(red: 0.4745098039215686, green: 0.8392156862745098, blue: 0.9764705882352941, alpha: 1.0) )],
        "orangeYellowGreenBluePurple2":  [ .orange, .yellow, .green, .blue, .purple],
        "woodTable" : [ Color( #colorLiteral(red: 0.11764705882352941, green: 0.0, blue: 0.06666666666666667, alpha: 1.0) ), Color( #colorLiteral(red: 0.30980392156862746, green: 0.20392156862745098, blue: 0.0392156862745098, alpha: 1.0) ), Color( #colorLiteral(red: 0.5058823529411764, green: 0.33725490196078434, blue: 0.06666666666666667, alpha: 1.0) ), Color( #colorLiteral(red: 0.7254901960784313, green: 0.47843137254901963, blue: 0.09803921568627451, alpha: 1.0) )] ,
        "reds":  [ Color( #colorLiteral(red: 0.30980392156862746, green: 0.01568627450980392, blue: 0.12941176470588237, alpha: 1.0) ), Color( #colorLiteral(red: 0.5725490196078431, green: 0.0, blue: 0.23137254901960785, alpha: 1.0) ), Color( #colorLiteral(red: 0.807843137254902, green: 0.027450980392156862, blue: 0.3333333333333333, alpha: 1.0) ), Color( #colorLiteral(red: 0.8549019607843137, green: 0.25098039215686274, blue: 0.47843137254901963, alpha: 1.0) )],
        "orangeYellowGreenBluePurple":  [ .orange, .yellow, .green, .blue, .purple],
    ]
        
    mutating func loadRandom() {
        colorGradient = Theme.colorGradients.values.randomElement()!
    }
}


///   Theme Background Gradients.
///
/// - An _Associated-Valued_ enum with **default** [Color] values.
/// - The default [Color] is returned with _rawValue_.
/// - _CaseIterable_ enables a random theme with `ThemeColorGradient.allCases.randomElement()`.
///
/// Usage:
/// `randomTheme = ThemeColorGradient.allCases.randomElement()`
///
/// `Gradient(colors: randomTheme!.rawValue )`
///
/// (Actually, Set game now uses a struct for color theme. Left this in as it was fun to craft an enum for theme.)
enum ThemeColorGradient: CaseIterable {
    
    static var allCases: [ThemeColorGradient]  {
        [.yellowOrangeRedPurple(), .greenFeltTable(), .woodTable()]
    }
    // Playing Table Backgrounds
    case yellowOrangeRedPurple( [Color] = [Color.yellow, Color.orange, Color.red, Color.purple] )
    
    case greenFeltTable( [Color] = [ Color( #colorLiteral(red: 0.09019607843137255, green: 0.13333333333333333, blue: 0.0392156862745098, alpha: 1.0) ), Color( #colorLiteral(red: 0.12941176470588237, green: 0.21568627450980393, blue: 0.06666666666666667, alpha: 1.0) ), Color( #colorLiteral(red: 0.19607843137254902, green: 0.3411764705882353, blue: 0.10196078431372549, alpha: 1.0) ), Color( #colorLiteral(red: 0.27450980392156865, green: 0.48627450980392156, blue: 0.1411764705882353, alpha: 1.0) )]  )
    
    case woodTable( [Color] = [ Color( #colorLiteral(red: 0.11764705882352941, green: 0.0, blue: 0.06666666666666667, alpha: 1.0) ), Color( #colorLiteral(red: 0.30980392156862746, green: 0.20392156862745098, blue: 0.0392156862745098, alpha: 1.0) ), Color( #colorLiteral(red: 0.5058823529411764, green: 0.33725490196078434, blue: 0.06666666666666667, alpha: 1.0) ), Color( #colorLiteral(red: 0.7254901960784313, green: 0.47843137254901963, blue: 0.09803921568627451, alpha: 1.0) )] )
    
    var rawValue: [Color] {
        getRawValue()
    }
    
    func getRawValue() -> [Color] {
        switch self {
        case let .yellowOrangeRedPurple(test): return test
        case let .greenFeltTable(test): return test
        case let .woodTable(test): return test
        }
    }
}


