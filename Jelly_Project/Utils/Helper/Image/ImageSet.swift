//
//  ImageSet.swift
//  Jelly_Project
//
//  Created by CatSlave on 5/7/24.
//

import Foundation
import UIKit

struct ImageSet {
    enum Name: String {
        case plus = "plus"
        case minus = "minus"
    }
    

    static func getImage(name: Name) -> UIImage? {
        return UIImage(named: name.rawValue)
    }
}
