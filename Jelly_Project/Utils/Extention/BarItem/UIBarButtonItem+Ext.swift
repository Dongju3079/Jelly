//
//  ButtonItem+Ext.swift
//  Jelly
//
//  Created by CatSlave on 4/20/24.
//

import Foundation
import UIKit

extension UIBarButtonItem {
    
    static func getImageItem(target: AnyObject?,
                             action: Selector?,
                             image: UIImage? = SymbolSet.getSymbolImage(name: .arrow, size: .large)) -> UIBarButtonItem {
            
        let item = UIBarButtonItem(image: image,
                                       style: .plain,
                                       target: target,
                                       action: action)
        
        item.tintColor = UIColorSet.button(.green2)
        
        return item
    }
    
    static func getTitleItem(target: AnyObject?,
                             action: Selector?,
                             title: String? = "완료",
                             titleSize: CGFloat = 20,
                             color: UIColorSet.Color.Text = .black) -> UIBarButtonItem {
            
        
        let item = UIBarButtonItem(title: title,
                                   style: .plain,
                                   target: target,
                                   action: action)
        
        
        item.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColorSet.text(color),
                                     NSAttributedString.Key.font: UIFont(customStyle: .bold, size: titleSize)!],
                                    for: .normal)
        
        return item
    }
}
