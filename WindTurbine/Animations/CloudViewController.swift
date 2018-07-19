//
//  CloudViewController.swift
//  WindTurbine
//
//  Created by Maciej Kowalski on 23.05.2018.
//  Copyright © 2018 Maciej Kowalski. All rights reserved.
//

import UIKit

extension GameViewController {
    
    func initCloudView(_ view: UIView) {
        
        //Add cloud and animate it
        var cloud = addCloud(to: view)
        animateCloud(cloud, in: view)
        let timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { (Timer) in
            if cloud.center.x > view.frame.maxX * 0.2 {
                //When the cloud moves past certain point add new one
                cloud = self.addCloud(to: view)
                self.animateCloud(cloud, in: view)
            }
        })
        timer.tolerance = 0.5
        
        addInitialClouds(to: view)
    }
    
    fileprivate func addInitialClouds(to view: UIView) {
        for x in [0.25, 0.5, 0.75] {
            let cloud = addCloud(to: view)
            cloud.center.x = view.frame.maxX * CGFloat(x)
            animateCloud(cloud, in: view)
        }
    }
    
    fileprivate func addCloud(to view: UIView) -> CloudView {
        let cloud = CloudView()
        let randomY = CGFloat(arc4random_uniform(UInt32(view.frame.midY/2 - cloud.frame.height)))
        cloud.center = CGPoint(x: -cloud.frame.width/2, y: cloud.frame.height/2 + randomY)
        
        view.addSubview(cloud)
        view.sendSubview(toBack: cloud)
        return cloud
    }
    
    fileprivate func animateCloud(_ cloud: CloudView, in view: UIView) {
        guard cloud.center.x < view.frame.size.width + cloud.frame.width else {
            cloud.removeFromSuperview()
            return
        }
        
        let time = 0.1/sqrt(TimeInterval(self.model.turbineRPM) * Double(cloud.randomSpeed))
        
        UIView.animate(withDuration: time, animations: {
            UIView.setAnimationCurve(.linear)
            cloud.center.x += 1
        }, completion: { (finished) in
            self.animateCloud(cloud, in: view)
        })
    }
    
    
}
