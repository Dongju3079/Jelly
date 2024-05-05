//
//  ButtonItem+Ext.swift
//  Jelly
//
//  Created by CatSlave on 4/20/24.
//

import Foundation
import UIKit

extension UIBarButtonItem {
    enum Mode {
        case left
        case right
    }
    
    static func getItem(mode: Mode = .left, target: AnyObject?, action: Selector?) -> UIBarButtonItem {
        
        let image = ImageSet.getImage(name: .arrow, size: .large)
        
        let leftItem = UIBarButtonItem(image: image,
                                       style: .plain,
                                       target: target,
                                       action: action)
        
        leftItem.tintColor = UIColorSet.button(.green2)
        
        return leftItem
    }
}
