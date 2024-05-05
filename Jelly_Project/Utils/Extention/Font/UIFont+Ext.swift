//
//  UIFont+Ext.swift
//  Jelly
//
//  Created by CatSlave on 4/20/24.
//

import Foundation
import UIKit

// MARK: - Color Set
extension UIFont {
    enum CustomFontStyle {
        case bold
        case medium
    }
    
    convenience init?(customStyle: CustomFontStyle, size: CGFloat) {
        switch customStyle {
        case .bold:
            self.init(name: "SpoqaHanSansNeo-Bold", size: size)
        case .medium:
            self.init(name: "SpoqaHanSansNeo-Medium", size: size)
        }
    }
}
