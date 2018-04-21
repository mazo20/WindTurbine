//
//  Double+Extension.swift
//  WindTurbine
//
//  Created by Maciej Kowalski on 18.04.2018.
//  Copyright © 2018 Maciej Kowalski. All rights reserved.
//

import Foundation


extension Double {
    /// Rounds the double to decimal places value
    func rounded(toPlaces places: Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
    
    func formatToString() -> String {
        var d = self.rounded(toPlaces: 2)
        if self > 100 {
            d = self.rounded(toPlaces: 0)
            return "\(Int(d))"
        }
        return ""
    }
    
    var moneyFormatter: String {
        
        if self >= 1000, self <= 999999 {
            return String(format: "%.1fk", locale: Locale.current,self/1000).replacingOccurrences(of: ".0", with: "")
        }
        if self > 999999, self <= 999999999 {
            return String(format: "%.1fM", locale: Locale.current,self/1000000).replacingOccurrences(of: ".0", with: "")
        }
        if self > 999999999 {
            return String(format: "%.1fB", locale: Locale.current,self/1000000).replacingOccurrences(of: ".0", with: "")
        }
        
        return String(format: "%.2f", locale: Locale.current,self).replacingOccurrences(of: ".00", with: "")
    }
    
    var powerFormatter: String {
        
        if self >= 1000, self <= 999999 {
            return String(format: "%.1fk", locale: Locale.current,self/1000).replacingOccurrences(of: ".0", with: "")
        }
        if self > 999999, self <= 999999999 {
            return String(format: "%.1fM", locale: Locale.current,self/1000000).replacingOccurrences(of: ".0", with: "")
        }
        if self > 999999999 {
            return String(format: "%.1fG", locale: Locale.current,self/1000000).replacingOccurrences(of: ".0", with: "")
        }
        
        return String(format: "%.2f", locale: Locale.current,self).replacingOccurrences(of: ".00", with: "")
    }
    
    
    
    func formatPowerToString() -> String {
        if self > 1000000000000 { return "T" }
        if self > 1000000000 { return "G" }
        if self > 1000000 { return "M" }
        if self > 1000 { return "k" }
        else { return "" }
    }
    
    func formatMoneyToString() -> String {
        if self > 1000 { return "T" }
        if self > 1000000 { return "B" }
        if self > 1000000 { return "M" }
        if self > 1000 { return "k" }
        else { return "" }
    }
    
    
}
