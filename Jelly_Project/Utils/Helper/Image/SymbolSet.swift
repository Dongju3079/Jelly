//
//  UIImageSet.swift
//  Jelly
//
//  Created by CatSlave on 4/20/24.
//

import Foundation
import UIKit


struct SymbolSet {
    
    enum Name: String {
        case trash = "trash.fill"
        case arrow = "chevron.left"
    }
    
    enum Size {
        case small
        case large
        
        var configuration: UIImage.SymbolConfiguration {
            switch self {
            case .small:
                return UIImage.SymbolConfiguration(pointSize: .zero, weight: .bold, scale: .small)
            case .large:
                return UIImage.SymbolConfiguration(pointSize: .zero, weight: .bold, scale: .large)
            }
        }
    }

    static func getSymbolImage(name: Name, size: Size) -> UIImage? {
        return UIImage(systemName: name.rawValue, withConfiguration: size.configuration)
    }
    
}
