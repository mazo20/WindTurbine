//
//  Double+Extension.swift
//  WindTurbine
//
//  Created by Maciej Kowalski on 18.04.2018.
//  Copyright © 2018 Maciej Kowalski. All rights reserved.
//

import Foundation


extension Double {
    enum formatterType {
        case power
        case income
        case balance
    }
    
    /// Rounds the double to decimal places value
    func rounded(toPlaces places: Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
   
    
    func numberFormatter(ofType type: formatterType) -> String {
        var string = ""
        if self < 1 && type != .balance {
            string = String(format: "%.3f", locale: Locale.current,self).replacingOccurrences(of: ".000", with: "")
        } else if self < 1000 || (self < 10000 && type == .balance){
            string = String(format: "%.2f", locale: Locale.current,self).replacingOccurrences(of: ".00", with: "")
        } else if self < 1000000 {
            string = String(format: "%.2fk", locale: Locale.current,self/1000).replacingOccurrences(of: ".00", with: "")
        } else if self < 1000000000 {
            string = String(format: "%.2fM", locale: Locale.current,self/1000000).replacingOccurrences(of: ".00", with: "")
        } else if self < 1000000000000 {
            if type == .power {
                string = String(format: "%.2fG", locale: Locale.current,self/1000000000).replacingOccurrences(of: ".00", with: "")
            } else {
                string = String(format: "%.2fB", locale: Locale.current,self/1000000000).replacingOccurrences(of: ".00", with: "")
            }
        } else {
            string = String(format: "%.2fT", locale: Locale.current,self/1000000000000).replacingOccurrences(of: ".00", with: "")
        }
        if string.contains(".") && string.last == "0" {
            string = String(string.dropLast())
        }
        if string.contains(".") && string.last == "0" {
            string = String(string.dropLast())
        }
        return string
        
        
    }
    
    
}
