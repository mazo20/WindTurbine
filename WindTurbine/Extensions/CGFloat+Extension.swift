//
//  CGFloat+Extension.swift
//  WindTurbine
//
//  Created by Maciej Kowalski on 23.05.2018.
//  Copyright © 2018 Maciej Kowalski. All rights reserved.
//

import UIKit

public extension CGFloat {
    /// Randomly returns either 1.0 or -1.0.
    public static var randomSign: CGFloat {
        get {
            return (arc4random_uniform(2) == 0) ? 1.0 : -1.0
        }
    }
    /// Returns a random floating point number between 0.0 and 1.0, inclusive.
    public static var random: CGFloat {
        get {
            return CGFloat(drand48())
        }
    }
    /**
     Create a random num CGFloat
     
     - parameter min: CGFloat
     - parameter max: CGFloat
     
     - returns: CGFloat random number
     */
    public static func random(min: CGFloat, max: CGFloat) -> CGFloat {
        return random * (max - min) + min
    }
}
