//
//  WindTurbineView.swift
//  WindTurbine
//
//  Created by Maciej Kowalski on 10.04.2018.
//  Copyright © 2018 Maciej Kowalski. All rights reserved.
//

import UIKit

class WindTurbineView: UIView {
    
    private var turbine: UIImageView?
    private var turbinePole: UIImageView?
    private var hill1: UIImageView?
    private var hill2: UIImageView?
    
    
    var model: Model? {
        didSet {
            self.turbine?.stopAnimating()
            rotateTurbine(withRPM: model!.turbineRPM)
            print("didSet")
            
        }
    }
    
    override init(frame: CGRect) {
       super.init(frame: frame)
        initSubviews()
        
    }
    
    convenience init() {
        self.init(frame: CGRect.zero)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initSubviews()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
    }
    
    override func draw(_ rect: CGRect) {
        
    }
    
    
    func initSubviews() {
        self.backgroundColor = .clear
        hill1 = UIImageView(image: #imageLiteral(resourceName: "Hill1"))
        hill2 = UIImageView(image: #imageLiteral(resourceName: "Hill2"))
        turbine = UIImageView(image: #imageLiteral(resourceName: "TurbineBlades"))
        turbinePole = UIImageView(image: #imageLiteral(resourceName: "TurbinePole"))
        self.addSubview(hill1!)
        self.addSubview(turbinePole!)
        self.addSubview(hill2!)
        self.addSubview(turbine!)
        hill1?.frame.size.height = frame.height * 0.4
        hill1?.frame.size.width = frame.height
        hill1?.center = CGPoint(x: frame.midX, y: frame.maxY)
        hill1?.layer.zPosition = 1
        
        let turbinePoleWidth = frame.size.height * 0.05
        let turbinePoleHeight = frame.size.height * 0.6
        turbinePole?.frame.size = CGSize(width: turbinePoleWidth, height: turbinePoleHeight)
        turbinePole?.center = CGPoint(x: frame.midX, y: frame.maxY * 0.7)
        turbinePole?.layer.zPosition = 1
        
        
        hill2?.frame.size.height = frame.height * 0.4
        hill2?.frame.size.width = frame.height
        hill2?.center = CGPoint(x: frame.midX, y: frame.maxY * 1.05)
        hill2?.layer.zPosition = 2
        
        
        let turbineBladesWidth = frame.size.height * 0.7
        turbine?.frame.size = CGSize(width: turbineBladesWidth, height: turbineBladesWidth)
        turbine?.center = CGPoint(x: frame.midX, y: (turbinePole?.frame.minY)!)
        turbine?.layer.zPosition = 3
        rotateTurbine()
    }
    
    func rotateTurbine() {
        if let model = model {
            rotateTurbine(withRPM: model.turbineRPM)
        }
        
    }
    
    private func rotateTurbine(withRPM rpm: Double) {
        let rotateBy = rpm/600
        UIView.animate(withDuration: 0.1, delay: 0.0, options: .curveLinear, animations: {
            self.turbine!.transform = self.turbine!.transform.rotated(by: 2 * .pi * CGFloat(rotateBy))
        }, completion: { (finished) in
            if let model = self.model {
                self.rotateTurbine(withRPM: model.turbineRPM)
            } else {
                self.rotateTurbine(withRPM: 0)
            }
            
        })
    }
    
}
