//
//  BackgroundView.swift
//  WindTurbine
//
//  Created by Maciej Kowalski on 11.04.2018.
//  Copyright © 2018 Maciej Kowalski. All rights reserved.
//

import UIKit

class BackgroundView: UIView {
    
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
        addClouds()
    }
    
    func addClouds() {
        print("backgroungView called")
        let _ = Timer.scheduledTimer(withTimeInterval: 5.0, repeats: true, block: { (Timer) in
            let cloud = CloudView()
            cloud.alpha = 0.9
            let y = cloud.frame.height/2 + CGFloat(arc4random_uniform(UInt32(self.frame.midY/2 - cloud.frame.height)))
            cloud.center = CGPoint(x: -cloud.frame.width/2, y: y)
            self.addSubview(cloud)
            self.sendSubview(toBack: cloud)
            
            let duration = Double(arc4random_uniform(30)) + 20
            UIView.animate(withDuration: duration, animations: {
                UIView.setAnimationCurve(.linear)
                cloud.center.x += self.frame.size.width + cloud.frame.width
            }, completion: { (finished) in
                cloud.removeFromSuperview()
            })
        })
    }
    
}
