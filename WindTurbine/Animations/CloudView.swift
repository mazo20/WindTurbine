//
//  CloudView.swift
//  WindTurbine
//
//  Created by Maciej Kowalski on 11.04.2018.
//  Copyright © 2018 Maciej Kowalski. All rights reserved.
//

import UIKit

class CloudView: UIImageView {
    
    let imageNames = ["Cloud1", "Cloud2", "Cloud3", "Cloud4"]
    var randomSpeed: CGFloat!
    
    override init(image: UIImage?) {
        super.init(image: image)
        setSize()
        alpha = 0.9
        randomSpeed = CGFloat.random(min: 0.85, max: 1.15)
    }
    
    convenience init() {
        self.init(image: nil)
        let index = Int(arc4random_uniform(UInt32(self.imageNames.count)))
        self.image = UIImage(imageLiteralResourceName: imageNames[index])
    }
    
    func setSize() {
        var height = CGFloat(arc4random_uniform(40)) + 40
        height = UIDevice.current.userInterfaceIdiom == .pad ? height * 1.5 : height
        self.frame.size = CGSize(width: height*2, height: height)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
