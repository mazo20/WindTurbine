//
//  UIView+Extension.swift
//  WindTurbine
//
//  Created by Maciej Kowalski on 10.04.2018.
//  Copyright © 2018 Maciej Kowalski. All rights reserved.
//

import UIKit

extension UIView {
    func rotateInfinitely(withInterval interval: CFTimeInterval) {
        let rotation = CABasicAnimation(keyPath: "transform.rotation")
        rotation.fromValue = 0.0
        rotation.toValue = 2 * Double.pi
        rotation.repeatCount = .infinity
        rotation.duration = interval
        self.layer.add(rotation, forKey: nil)
    }
}
