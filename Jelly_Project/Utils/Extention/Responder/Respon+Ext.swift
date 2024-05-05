//
//  UIView+Ext.swift
//  Jelly
//
//  Created by CatSlave on 3/18/24.
//

import Foundation
import UIKit

// MARK: - Responder
extension UIResponder {
    
    private struct Static {
        static weak var responder: UIResponder?
    }
    
    static var currentResponder: UIResponder? {
        Static.responder = nil
        UIApplication.shared.sendAction(#selector(UIResponder._trap), to: nil, from: nil, for: nil)
        return Static.responder
    }
    
    @objc private func _trap() {
        Static.responder = self
    }
}


