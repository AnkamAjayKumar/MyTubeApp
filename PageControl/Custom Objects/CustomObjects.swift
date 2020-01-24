//
//  CustomObjects.swift
//  PageControl
//
//  Created by Ankam Ajay Kumar on 10/12/19.
//  Copyright © 2019 Ankam Ajay Kumar. All rights reserved.
//

import UIKit

extension UIButton
{
    func pulseButton()
    {
        let pulseBtn = CASpringAnimation(keyPath: "transform.scale")
        pulseBtn.duration = 0.6
        pulseBtn.fromValue = 0.95
        pulseBtn.toValue = 1
        pulseBtn.autoreverses = true
        pulseBtn.repeatCount = 2
        pulseBtn.initialVelocity = 0.5
        pulseBtn.damping = 1.0
        
        layer.add(pulseBtn, forKey: nil)
    }
}

