//
//  CommonViewType.swift
//  Jelly
//
//  Created by CatSlave on 5/3/24.
//

import Foundation

enum EnterType {
    case name
    case food
    case status
    case weight
    case calorie
    
    var gauge: Float {
        switch self {
        case .name:
            0.2
        case .food:
            0.4
        case .status:
            0.6
        case .weight:
            0.8
        case .calorie:
            1.0
        }
    }
    
    var title: String {
        switch self {
        case .name:
            "반려묘의 이름을 선택해주세요."
        case .food:
            "어떤 방식으로 급여하고 있나요?"
        case .status:
            "반려묘의 상태를 선택해주세요."
        case .weight:
            "반려묘의 몸무게를 입력하세요."
        case .calorie:
            "급여중인 사료의 칼로리를 입력하세요."
        }
    }
}
