//
//  ScaledWidthImageView.swift
//  WindTurbine
//
//  Created by Maciej Kowalski on 06.06.2018.
//  Copyright © 2018 Maciej Kowalski. All rights reserved.
//

import UIKit

class ScaledWidthImageView: UIImageView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override var intrinsicContentSize: CGSize {
        
        if let myImage = self.image {
            let myImageWidth = myImage.size.width
            let myImageHeight = myImage.size.height
            let myViewHeight = self.frame.size.height
            
            let ratio = myViewHeight/myImageHeight
            let scaledWidth = myImageWidth * ratio
            
            return CGSize(width: scaledWidth, height: myViewHeight)
        }
        
        return CGSize(width: -1.0, height: -1.0)
    }
    
}
