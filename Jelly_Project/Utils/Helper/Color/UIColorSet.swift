//
//  ColorCode.swift
//  Jelly
//
//  Created by CatSlave on 4/19/24.
//

import Foundation
import UIKit

struct UIColorSet {
    
    enum Color {
        
        enum Text: String {
            case green = "9FC1B7"
            case green2 = "A5C7BD"
            case green3 = "5FA690"
            case black = "2C2C2C"
        }
        
        enum BackColor: String {
            case green = "EBF3F0"
            case shadow = "BBD1C9"
            case border = "DCE8E4"
            case transparent = "FFFFFF"
        }
        
        enum Progress: String {
            case green = "DCE8E4"
            case green2 = "6CC1A7"
        }
        
        enum Button: String {
            case green = "6CC1A7"
            case green2 = "A5C7BD"
            case gray = "696B72"
        }
    }
    
    static func text(_ color: Color.Text) -> UIColor {
        return UIColor(color.rawValue)
    }
    
    static func background(_ color: Color.BackColor, _ alpha: CGFloat = 1.0) -> UIColor {
        return UIColor(color.rawValue, alpha)
    }
    
    static func progress(_ color: Color.Progress) -> UIColor {
        return UIColor(color.rawValue)
    }
    
    static func button(_ color: Color.Button) -> UIColor {
        return UIColor(color.rawValue)
    }
}
