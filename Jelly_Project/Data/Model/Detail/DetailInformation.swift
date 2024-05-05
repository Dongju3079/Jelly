//
//  resultModel.swift
//  Jelly
//
//  Created by CatSlave on 3/13/24.
//

import Foundation



class DetailInformation: NSObject {
    
    var uuid: String?
    var date: Date = Date()
    var foodType: FoodType?
    var status: StatusType?
    var weight: Double
    var wetFeedCalorie: Double?
    var dryFeedCalorie: Double?
    var dryFeedUnit: Double
    

    init(date: Date = Date(),
         foodType: FoodType? = nil,
         wetFeedCalorie: Double? = nil,
         dryFeedCalorie: Double? = nil,
         dryFeedUnit: Double = 1_000.0,
         status: StatusType? = nil,
         weight: Double = 5.0) {
        
        self.date = date
        self.foodType = foodType
        self.dryFeedUnit = dryFeedUnit
        self.status = status
        self.weight = weight
    }
    
    init(memoEntity: DetailInformationEntity) {
        self.uuid = memoEntity.id
        self.date = memoEntity.createdDate
        self.foodType = FoodType(rawValue: memoEntity.foodTypeRawValue ?? 0)
        self.status = StatusType(rawValue: memoEntity.statusTypeRawValue ?? 0)
        self.weight = memoEntity.weight ?? 5.0
        self.wetFeedCalorie = memoEntity.wetFeedCalorie ?? 0
        self.dryFeedCalorie = memoEntity.dryFeedCalorie ?? 0
        self.dryFeedUnit = memoEntity.dryFeedUnit ?? 1_000.0
    }
    
    static func == (lhs: DetailInformation, rhs: DetailInformation) -> Bool {
            return lhs.date == rhs.date
    }
}

// MARK: - 계산 메서드
extension DetailInformation {
    
    var dateString: String? {
        let myFormatter = DateFormatter()
        myFormatter.dateFormat = "yyyy-MM-dd"
        let savedDateString = myFormatter.string(from: date)
        return savedDateString
    }
    
    
    func calculateRER() -> Double {
        
        return (weight * 30) + 70
    }
    
    func adequateCalorie() -> Double {
        let RER = calculateRER()
        
        let DER = status?.figure ?? 0
        
        let result = (RER * DER).rounded()

        return result
    }
    
    func maxWetFeedCount() -> Int {
        guard let wetFeedCalorie = wetFeedCalorie else { return 0 }
        let calorie = adequateCalorie()
        let maxCount = Int(floor(calorie / wetFeedCalorie))
        
        return maxCount
        
    }
    
    func dryFeedConvertOfUnit() -> Double {
        guard let dryFeedCalorie = dryFeedCalorie else { return 0 }
        return dryFeedCalorie / dryFeedUnit
    }

}
