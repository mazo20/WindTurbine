//
//  TurbineViewController.swift
//  WindTurbine
//
//  Created by Maciej Kowalski on 23.05.2018.
//  Copyright © 2018 Maciej Kowalski. All rights reserved.
//

import UIKit

extension GameViewController {
    
    func initTurbineView() {
        addBackground()
        addTurbine()
    }
    
    fileprivate func addBackground() {
        windTurbineView.backgroundColor = .clear
        let frame = windTurbineView.frame
        let hill1 = UIImageView(image: #imageLiteral(resourceName: "Hill1"))
        hill1.frame.size.height = frame.height * 0.4
        hill1.frame.size.width = frame.height*1.1
        hill1.center = CGPoint(x: frame.midX, y: frame.maxY)
        hill1.layer.zPosition = 1
        
        let hill2 = UIImageView(image: #imageLiteral(resourceName: "Hill2"))
        hill2.frame.size.height = frame.height * 0.4
        hill2.frame.size.width = frame.height*1.1
        hill2.center = CGPoint(x: frame.midX, y: frame.maxY * 1.05)
        hill2.layer.zPosition = 2
        
        windTurbineView.addSubview(hill1)
        windTurbineView.addSubview(hill2)
    }
    
    fileprivate func addTurbine() {
        let frame = windTurbineView.frame
        let turbinePoleWidth = frame.size.height * 0.05
        let turbinePoleHeight = frame.size.height * 0.6
        let turbinePole = UIImageView(image: #imageLiteral(resourceName: "TurbinePole"))
        turbinePole.frame.size = CGSize(width: turbinePoleWidth, height: turbinePoleHeight)
        turbinePole.center = CGPoint(x: frame.midX, y: frame.maxY * 0.7)
        turbinePole.layer.zPosition = 1
        
        let rotor = UIImageView(image: #imageLiteral(resourceName: "TurbineBlades"))
        let turbineBladesWidth = frame.size.height * 0.7
        rotor.frame.size = CGSize(width: turbineBladesWidth, height: turbineBladesWidth)
        rotor.center = CGPoint(x: frame.midX, y: turbinePole.frame.minY)
        rotor.layer.zPosition = 3
        
        windTurbineView.addSubview(turbinePole)
        windTurbineView.addSubview(rotor)
        
        rotateTurbine(rotor, withRPM: model.turbineRPM)
    }
    
    fileprivate func rotateTurbine(_ turbine: UIImageView, withRPM rpm: Double) {
        let rotateBy = rpm/600
        UIView.animate(withDuration: 0.1, delay: 0.0, options: .curveLinear, animations: {
            turbine.transform = turbine.transform.rotated(by: 2 * .pi * CGFloat(rotateBy))
        }, completion: { (finished) in
            self.rotateTurbine(turbine, withRPM: self.model.turbineRPM)
        })
    }
}
