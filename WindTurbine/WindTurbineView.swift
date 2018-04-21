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
    
    var model: Model! {
        didSet {
            turbine.stopAnimating()
            rotateTurbine(withRPM: model.turbineRPM)
        }
    }
    
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
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        
    }
    
    
    func addBehaviour() {
        let hill1 = UIImageView(image: #imageLiteral(resourceName: "Hill1"))
        hill1.frame.size.height = frame.height * 0.4
        hill1.frame.size.width = frame.height
        hill1.center = CGPoint(x: frame.midX, y: frame.maxY)
        hill1.layer.zPosition = 1
        self.addSubview(hill1)
        
        let turbinePole = UIImageView(image: #imageLiteral(resourceName: "TurbinePole"))
        let turbinePoleWidth = frame.size.height * 0.05
        let turbinePoleHeight = frame.size.height * 0.6
        turbinePole.frame.size = CGSize(width: turbinePoleWidth, height: turbinePoleHeight)
        turbinePole.center = CGPoint(x: frame.midX, y: frame.maxY * 0.7)
        turbinePole.layer.zPosition = 1
        self.addSubview(turbinePole)
        
        let hill2 = UIImageView(image: #imageLiteral(resourceName: "Hill2"))
        hill2.frame.size.height = frame.height * 0.4
        hill2.frame.size.width = frame.height
        hill2.center = CGPoint(x: frame.midX, y: frame.maxY * 1.05)
        hill2.layer.zPosition = 2
        self.addSubview(hill2)
        
        let turbineBlades = UIImageView(image: #imageLiteral(resourceName: "TurbineBlades"))
        let turbineBladesWidth = frame.size.height * 0.7
        turbineBlades.frame.size = CGSize(width: turbineBladesWidth, height: turbineBladesWidth)
        turbineBlades.center = CGPoint(x: frame.midX, y: turbinePole.frame.minY)
        turbineBlades.layer.zPosition = 3
        turbine = turbineBlades
        self.addSubview(turbineBlades)
        
        
    }
    
    private func rotateTurbine(withRPM rpm: Double) {
        let rotateBy = rpm/600
        UIView.animate(withDuration: 0.1, delay: 0.0, options: .curveLinear, animations: {
            self.turbine.transform = self.turbine.transform.rotated(by: 2 * .pi * CGFloat(rotateBy) )
        }, completion: { (finished) in
            guard self.model.turbineRPM != 0 else { return }
            self.rotateTurbine(withRPM: self.model.turbineRPM)
        })
    }
    
}
