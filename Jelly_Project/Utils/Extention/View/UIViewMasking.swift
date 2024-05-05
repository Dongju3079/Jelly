//
//  CALayer+Ext.swift
//  Jelly
//
//  Created by CatSlave on 5/2/24.
//

import Foundation
import UIKit

extension UIView {
    func addMasking() {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [
            UIColorSet.background(.green).cgColor,
            UIColor.clear.cgColor
        ]
        
        gradientLayer.frame = self.bounds
        
        self.layer.mask = gradientLayer
    }
}
