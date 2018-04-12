//
//  WindTurbineView.swift
//  WindTurbine
//
//  Created by Maciej Kowalski on 10.04.2018.
//  Copyright © 2018 Maciej Kowalski. All rights reserved.
//

import UIKit

class WindTurbineView: UIView {
    
    private var turbine: UIImageView!
    
    var rpm: Double = 10
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addBehaviour()
    }
    
    convenience init() {
        self.init(frame: CGRect.zero)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        addBehaviour()
    }
    
    func addBehaviour() {
        let turbinePole = UIImageView(image: #imageLiteral(resourceName: "TurbinePole"))
        let turbinePoleWidth = frame.size.height * 0.05
        let turbinePoleHeight = frame.size.height * 0.6
        turbinePole.frame.size = CGSize(width: turbinePoleWidth, height: turbinePoleHeight)
        turbinePole.center = CGPoint(x: frame.midX, y: frame.maxY * 0.7)
        turbinePole.layer.zPosition = 2
        self.addSubview(turbinePole)
        
        let turbineBlades = UIImageView(image: #imageLiteral(resourceName: "TurbineBlades"))
        let turbineBladesWidth = frame.size.height * 0.6
        turbineBlades.frame.size = CGSize(width: turbineBladesWidth, height: turbineBladesWidth)
        turbineBlades.center = CGPoint(x: frame.midX, y: turbinePole.frame.minY)
        turbineBlades.layer.zPosition = 3
        turbine = turbineBlades
        self.addSubview(turbineBlades)
        
        
        
        rotateTurbine(withRPM: rpm)
    }
    
    private func rotateTurbine(withRPM rpm: Double) {
        let rotationTime = 60/rpm
        UIView.animate(withDuration: rotationTime/10, delay: 0.0, options: .curveLinear, animations: {
            self.turbine.transform = self.turbine.transform.rotated(by: 2 * .pi/10 )
        }, completion: { (finished) in
            guard self.rpm != 0 else { return }
            self.rotateTurbine(withRPM: self.rpm)
        })
    }
    
}
