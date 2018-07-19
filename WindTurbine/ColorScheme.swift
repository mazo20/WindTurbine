//
//  ColorScheme.swift
//  WindTurbine
//
//  Created by Maciej Kowalski on 30.06.2018.
//  Copyright © 2018 Maciej Kowalski. All rights reserved.
//

import UIKit

struct ColorScheme {
    
    
    
    static let menuColor = #colorLiteral(red: 0.3137254902, green: 0.3176470588, blue: 0.3098039216, alpha: 1)
    
    static var backgroundColor: UIColor {
        let gameLevel = GameLevel.getPlanet()
        switch gameLevel {
        case .earth:
            return #colorLiteral(red: 0.3960784314, green: 0.8156862745, blue: 0.9098039216, alpha: 1)
        case .moon:
            return #colorLiteral(red: 0.003921568627, green: 0.4156862745, blue: 0.5058823529, alpha: 1)
        case .mars:
            return #colorLiteral(red: 0.7529411765, green: 0.1568627451, blue: 0.2352941176, alpha: 1)
        }
    }
    
    static var buttonColor: UIColor {
        let gameLevel = GameLevel.getPlanet()
        switch gameLevel {
        case .earth:
            return #colorLiteral(red: 0.9450980392, green: 0.8588235294, blue: 0.2941176471, alpha: 1)
        case .moon:
            return #colorLiteral(red: 0.737254902, green: 0.9058823529, blue: 0.9921568627, alpha: 1)
        case .mars:
            return #colorLiteral(red: 1, green: 0.5568627451, blue: 0.1529411765, alpha: 1)
        }
    }
    
    static var labelColor: UIColor {
        let gameLevel = GameLevel.getPlanet()
        switch gameLevel {
        case .earth:
            return #colorLiteral(red: 0.9450980392, green: 0.8588235294, blue: 0.2941176471, alpha: 1)
        case .moon:
            return #colorLiteral(red: 0.737254902, green: 0.9058823529, blue: 0.9921568627, alpha: 1)
        case .mars:
            return #colorLiteral(red: 1, green: 0.5568627451, blue: 0.1529411765, alpha: 1)
        }
    }
    
    static var frontHillColor: UIColor {
        let gameLevel = GameLevel.getPlanet()
        switch gameLevel {
        case .earth:
            return #colorLiteral(red: 0, green: 0.5411764706, blue: 0.3843137255, alpha: 1)
        case .moon:
            return #colorLiteral(red: 0.6039215686, green: 0.6274509804, blue: 0.6588235294, alpha: 1)
        case .mars:
            return #colorLiteral(red: 0.4117647059, green: 0.07843137255, blue: 0.05490196078, alpha: 1)
        }
    }
    
    static var backHillColor: UIColor {
        let gameLevel = GameLevel.getPlanet()
        switch gameLevel {
        case .earth:
            return #colorLiteral(red: 0, green: 0.6274509804, blue: 0.3843137255, alpha: 1)
        case .moon:
            return #colorLiteral(red: 0.4666666667, green: 0.5294117647, blue: 0.5450980392, alpha: 1)
        case .mars:
            return #colorLiteral(red: 0.3411764706, green: 0.02352941176, blue: 0, alpha: 1)
        }
    }
    
    
    
    
    
}
