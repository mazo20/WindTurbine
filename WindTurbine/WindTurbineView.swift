//
//  WindTurbineView.swift
//  WindTurbine
//
//  Created by Maciej Kowalski on 10.04.2018.
//  Copyright © 2018 Maciej Kowalski. All rights reserved.
//

import UIKit

class WindTurbineView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        print("init")
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
        let turbinePoleWidth = frame.size.height/20
        let turbinePoleHeight = frame.size.height/2
        turbinePole.frame.size = CGSize(width: turbinePoleWidth, height: turbinePoleHeight)
        turbinePole.center = CGPoint(x: frame.midX, y: frame.maxY*2/3)
        self.addSubview(turbinePole)
        
        let turbineBlades = UIImageView(image: #imageLiteral(resourceName: "TurbineBlades"))
        let turbineBladesWidth = frame.size.height/2
        turbineBlades.frame.size = CGSize(width: turbineBladesWidth, height: turbineBladesWidth)
        turbineBlades.center = CGPoint(x: frame.midX, y: turbinePole.frame.minY)
        turbineBlades.rotateInfinitely(withInterval: 5.0)
        self.addSubview(turbineBlades)
        print("added")
    }
}
