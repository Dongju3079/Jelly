//
//  FoodType.swift
//  Jelly
//
//  Created by CatSlave on 5/4/24.
//

import Foundation

enum FoodType: Int, Selectable, Codable, CaseIterable {
    
    case wet = 0
    case dry = 1
    case mix = 2
    
    var title : String {
        switch self {
        case .wet:
            return "습식"
        case .dry:
            return "건식"
        case .mix:
            return "혼합"
        }
    }
}

extension FoodType {
    static func getAllTypes() -> [Self] {

        return FoodType.allCases
    }
}
