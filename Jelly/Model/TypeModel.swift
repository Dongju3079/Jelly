//
//  Model.swift
//  Jelly
//
//  Created by CatSlave on 3/15/24.
//

import Foundation

enum FoodType: CaseIterable {
    
    case wet
    case dry
    case mix
    
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
    
}

enum StatusType: CaseIterable {
    case growthPeriod
    case oldAge
    case obesity
    case lotOfActivity
    case neutered
    case notNeutered
    
    var title: String {
        switch self {
        case .growthPeriod:
            return "성장기"
        case .oldAge:
            return "고령묘"
        case .obesity:
            return "비만"
        case .lotOfActivity:
            return "저체중"
        case .neutered:
            return "중성화 O"
        case .notNeutered:
            return "중성화 X"
        }
    }
    
    var figure: Double {
        switch self {
        case .growthPeriod:
            return 2.0
        case .oldAge:
            return 1.1
        case .obesity:
            return 1.0
        case .lotOfActivity:
            return 1.6
        case .neutered:
            return 1.2
        case .notNeutered:
            return 1.4
        }
    }
}
