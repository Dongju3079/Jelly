//
//  UIMenu+Ext.swift
//  Jelly
//
//  Created by CatSlave on 4/30/24.
//

import Foundation
import UIKit

extension UIMenu {
    
    static func setupCountMenu(action: ((Int) -> UIAction)? = nil,
                               maxCount: Int) -> UIMenu? {
        
        var actions: [UIAction] = []
        if maxCount >= 1 {
            for count in 0...maxCount {
                guard let action = action?(count) else { break }
                actions.append(action)
            }
            
            let menu = UIMenu(title: "습식 갯수", children: actions)
            
            return menu
        } else {
            return nil
        }
    }
}
