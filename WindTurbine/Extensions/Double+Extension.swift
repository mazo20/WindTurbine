//
//  Double+Extension.swift
//  WindTurbine
//
//  Created by Maciej Kowalski on 18.04.2018.
//  Copyright © 2018 Maciej Kowalski. All rights reserved.
//

import Foundation

enum formatterType: String {
    case power
    case income
    case balance
    case wind
    case powerPerKm
    case pricePerW
    case capacity
    case cost
    case charging
    case price
}

extension Double {
    
    /// Rounds the double to decimal places value
    func rounded(toPlaces places: Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
   
    
    func numberFormatter(ofType type: formatterType) -> String {
        var string = ""
        var endingLetter: String?
        switch (self, type) {
        case (0..<1, .balance):
            string = String(format: "%.2f", locale: Locale.current, self)
        case (0..<1, _):
            string = String(format: "%.3f", locale: Locale.current, self)
        case (1..<1000, _):
            string = String(format: "%.2f", locale: Locale.current, self)
        case (1..<10000, .balance):
            string = String(format: "%.2f", locale: Locale.current, self)
        case (1000..<1000000, _):
            string = String(format: "%.2fk", locale: Locale.current, self/1000)
            endingLetter = "k"
        case (1000000..<1000000000, _):
            string = String(format: "%.2fM", locale: Locale.current, self/1000000)
            endingLetter = "M"
        case (1000000000..<1000000000000, .power):
            string = String(format: "%.2fG", locale: Locale.current, self/1000000000)
            endingLetter = "G"
        case (1000000000..<1000000000000, _):
            string = String(format: "%.2fB", locale: Locale.current, self/1000000000)
            endingLetter = "B"
        case (1000000000000..<1000000000000000, _):
            string = String(format: "%.2fT", locale: Locale.current, self/1000000000000)
            endingLetter = "T"
        default:
            string = String(format: "%.2fkT", locale: Locale.current, self/1000000000000000)
            endingLetter = "kT"
        }
        if type == .balance { return string }
        if let separator = Locale.current.decimalSeparator, let letter = endingLetter {
            string = string.replacingOccurrences(of: "0\(letter)", with: letter).replacingOccurrences(of: "0\(letter)", with: letter).replacingOccurrences(of: "0\(letter)", with: letter).replacingOccurrences(of: "\(separator)\(letter)", with: letter)
        }
        if let separator = Locale.current.decimalSeparator {
            for _ in 1...4 {
                if string.contains(separator) && (string.last == "0" || string.last == separator.first) {
                    string = String(string.dropLast())
                }
            }
        }
        return string
        
    }
    
    func valueFormatter(ofType type: formatterType) -> String {
        switch type {
        case .wind:
            return numberFormatter(ofType: .income) + "km/h"
        case .power, .charging:
            return numberFormatter(ofType: .power) + "W"
        case .income:
            return "$" + numberFormatter(ofType: .income) + "/s"
        case .balance:
            return "$" + numberFormatter(ofType: .balance)
        case .powerPerKm:
            return numberFormatter(ofType: .power) + "W/(km/h)"
        case .pricePerW, .price:
            return numberFormatter(ofType: .power) 
        case .cost:
            return "$" + numberFormatter(ofType: .income)
        default:
            return numberFormatter(ofType: .power) + "Wh"
        }
    }
    
    public static func random(min: Double, max: Double) -> Double {
        return drand48() * (max - min) + min
    }
    
    
}
