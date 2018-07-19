//
//  TurbineView.swift
//  WindTurbine
//
//  Created by Maciej Kowalski on 02.07.2018.
//  Copyright © 2018 Maciej Kowalski. All rights reserved.
//

import UIKit

class TurbineView: UIView {
    
    var frontHill: UIImageView?
    var backHill: UIImageView?
    var turbinePole: UIImageView?
    var turbineRotor: UIImageView?
    var model: Model? {
        didSet {
            print("KURWAAAAAA")
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    func commonInit() {
        backHill = UIImageView(image: #imageLiteral(resourceName: "Hill1"))
        backHill!.tintColor = ColorScheme.backHillColor
        backHill!.frame.size.height = frame.height * 0.4
        backHill!.frame.size.width = frame.height*1.2
        backHill!.center = CGPoint(x: frame.midX, y: frame.maxY)
        backHill!.layer.zPosition = 1
        
        frontHill = UIImageView(image: #imageLiteral(resourceName: "Hill2"))
        frontHill!.tintColor = ColorScheme.frontHillColor
        frontHill!.frame.size.height = frame.height * 0.4
        frontHill!.frame.size.width = frame.height*1.2
        frontHill!.center = CGPoint(x: frame.midX, y: frame.maxY * 1.05)
        frontHill!.layer.zPosition = 2
        
        let turbinePoleWidth = frame.size.height * 0.05
        let turbinePoleHeight = frame.size.height * 0.6
        turbinePole = UIImageView(image: #imageLiteral(resourceName: "TurbinePole"))
        turbinePole!.frame.size = CGSize(width: turbinePoleWidth, height: turbinePoleHeight)
        turbinePole!.center = CGPoint(x: frame.midX, y: frame.maxY * 0.7)
        turbinePole!.layer.zPosition = 1
        
        turbineRotor = UIImageView(image: #imageLiteral(resourceName: "TurbineBlades"))
        let turbineBladesWidth = frame.size.height * 0.7
        turbineRotor!.frame.size = CGSize(width: turbineBladesWidth, height: turbineBladesWidth)
        turbineRotor!.center = CGPoint(x: frame.midX, y: turbinePole!.frame.minY)
        turbineRotor!.layer.zPosition = 3
        
        
        self.addSubview(frontHill!)
        self.addSubview(backHill!)
        
        self.addSubview(turbinePole!)
        self.addSubview(turbineRotor!)
        
        rotateTurbine(turbineRotor!, withRPM: 1)
    }
    
    fileprivate func rotateTurbine(_ turbine: UIImageView, withRPM rpm: Double) {
        let rotateBy = rpm/600
        UIView.animate(withDuration: 0.1, delay: 0.0, options: .curveLinear, animations: {
            turbine.transform = turbine.transform.rotated(by: 2 * .pi * CGFloat(rotateBy))
        }, completion: { (finished) in
            if let model = self.model {
                self.rotateTurbine(turbine, withRPM: model.turbineRPM)
            } else {
                self.rotateTurbine(turbine, withRPM: 1)
            }
            
        })
    }
    
}
