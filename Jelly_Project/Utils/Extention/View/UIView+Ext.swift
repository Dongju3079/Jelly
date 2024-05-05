//
//  UIView+Ext.swift
//  Jelly
//
//  Created by CatSlave on 4/20/24.
//

import Foundation
import UIKit

extension UIView {
    
    /// addSubview 배열로 하기
    /// - Parameter views: 추가할 [View]
    func addSubviews(_ views: [UIView]) {
        for view in views {
            self.addSubview(view)
        }
    }
    
    func findViewController() -> UIViewController? {
        if let nextResponder = self.next as? UIViewController {
            return nextResponder
        } else if let nextResponder = self.next as? UIView {
            return nextResponder.findViewController()
        } else {
            return nil
        }
    }
}
