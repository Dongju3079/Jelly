//
//  CustomProgressBar.swift
//  Jelly
//
//  Created by CatSlave on 5/2/24.
//

import Foundation
import UIKit

class CustomProgressBar: UIProgressView {

    static var currentPercent: Float = 0.0
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setUI()
        setGauge()
    }
    
    fileprivate func setUI() {
        layer.cornerRadius = 5
        progressTintColor = UIColorSet.progress(.green2)
        trackTintColor = UIColorSet.progress(.green)
    }
    
    fileprivate func setGauge() {
        self.setProgress(Self.currentPercent, animated: false)
    }
    
    func raiseGauge(enterType: EnterType, animated: Bool = true) {
        Self.currentPercent = enterType.gauge
        
        DispatchQueue.main.async {
            UIView.animate(withDuration: 1) {
                self.setProgress(Self.currentPercent, animated: animated)
            }
        }
    }
    
    func downGauge() {
        Self.currentPercent -= 0.2
    }
    
    static func resetGauge() {
        Self.currentPercent = 0.0
    }
    
    
    
}
