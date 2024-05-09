//
//  Model.swift
//  Jelly
//
//  Created by CatSlave on 3/15/24.
//

import Foundation

enum StatusType: Int, Selectable, Codable, CaseIterable {
    case kitten = 0
    case adult = 1
    case senior = 2
    case thin = 3
    case ideal = 4
    case obesity = 5
    case neutered = 6
    case notNeutered = 7
    
    var title: String {
        switch self {
        case .kitten:
            return "성장기"
        case .adult:
            return "성묘"
        case .senior:
            return "고령묘"
        case .thin:
            return "마른"
        case .ideal:
            return "적정"
        case .obesity:
            return "비만"
        case .neutered:
            return "중성화"
        case .notNeutered:
            return "비중성화"
        }
    }
    
    var figure: Double {
        switch self {
        case .kitten:
            return 2.0
        case .adult:
            return 1.0
        case .senior:
            return 1.1
        case .thin:
            return 1.6
        case .ideal:
            return 1.0
        case .obesity:
            return 1.0
        case .neutered:
            return 1.2
        case .notNeutered:
            return 1.4
        }
    }
    
    var priority: Int {
        switch self {
        case .kitten, .adult, .senior:
            return 0
        case .obesity, .ideal, .thin:
            return 1
        case .neutered, .notNeutered:
            return 2
        }
    }
}

extension StatusType {
    
    static func getAllTypesOfPriority(priority: Int) -> [Self] {
                
        let statusTypes: [StatusType] = StatusType.allCases
            .filter { $0.priority == priority }
        
        return statusTypes
    }

}
