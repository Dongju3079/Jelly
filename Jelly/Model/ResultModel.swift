//
//  resultModel.swift
//  Jelly
//
//  Created by CatSlave on 3/13/24.
//

import Foundation

// 섹션 배열
struct allData {
    var data: [ResultSection]
}

// 섹션
struct ResultSection {
    var uuid = UUID()
    var date = Date()
    var name: String
    var row: [ResultModel]
}


// 로우
struct ResultModel {
    
    var date: Date = Date()
    var name: String?
    var foodType: FoodType?
    var wetFeedCalorie: Double?
    var dryFeedCalorie: Double?
    var status: StatusType?
    var weight: Double?
    
    func calculateRER() -> Double {
        let currentWeight = weight ?? 0
        
        return (currentWeight * 30) + 70
    }
    
    func adequateCalorie() -> Double {
        let RER = calculateRER()
        
        let DER = status?.figure ?? 0
        
        return RER * DER
    }
    
    func maxWetFeedCount() -> Int {
        let calorie = adequateCalorie()
        let maxCount = Int(floor(calorie / (self.wetFeedCalorie ?? 0)))
        
        return maxCount
    }
}
