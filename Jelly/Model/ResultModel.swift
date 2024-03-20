//
//  resultModel.swift
//  Jelly
//
//  Created by CatSlave on 3/13/24.
//

import Foundation

// 섹션 배열


// 섹션
struct ResultSection {
    var name: String
    var row: [ResultModel]
}


// 로우
struct ResultModel {
    
    // 생성일
    var date: Date = Date()
    
    // 반려동물 이름
    var name: String?
    
    // foodType 에 따라서 몇개의 textField를 표시할 지 정하면 됨
    var foodType: FoodType?
    
    // 상태
    var status: StatusType?
    
    // 몸무게
    var weight: Double?
}
