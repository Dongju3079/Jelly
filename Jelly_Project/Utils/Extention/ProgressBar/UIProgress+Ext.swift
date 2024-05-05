//
//  UIProgress+Ext.swift
//  Jelly
//
//  Created by CatSlave on 4/20/24.
//

import Foundation
import UIKit

// MARK: - ProgressView Setup
extension UIProgressView {
    func setupProgressBar(progressBar: UIProgressView,
                          before: Float,
                          next: Float,
                          animated: Bool = true) {
        
        progressBar.layer.cornerRadius = 5
        progressBar.setProgress(before, animated: false)
        progressBar.progressTintColor = UIColorSet.progress(.green2)
        progressBar.trackTintColor = UIColorSet.progress(.green)
        
        DispatchQueue.main.async {
            UIView.animate(withDuration: 1) {
                progressBar.setProgress(next, animated: animated)
            }
        }
    }
}
