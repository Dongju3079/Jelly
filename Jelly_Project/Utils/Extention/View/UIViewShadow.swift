//
//  UIViewShadow.swift
//  Jelly
//
//  Created by CatSlave on 5/2/24.
//

import Foundation
import UIKit

extension UIView {
    
    func makeShadow() {
        self.layer.cornerRadius = 8
        self.layer.shadowRadius = 8
        self.layer.shadowOpacity = 0.5
        self.layer.shadowColor = UIColorSet.background(.shadow).cgColor
        self.layer.shadowOffset = CGSize(width: 2, height: 2)
    }
}
