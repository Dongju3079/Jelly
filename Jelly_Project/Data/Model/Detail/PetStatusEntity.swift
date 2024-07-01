//
//  MemoEntity.swift
//  Jelly
//
//  Created by CatSlave on 3/26/24.
//

import Foundation
import RealmSwift

class PetStatusEntity: Object {
    
    @Persisted(primaryKey: true) var _id: ObjectId
    @Persisted var createdDate: Date = Date()
    @Persisted var foodTypeRawValue: Int?
    @Persisted var statusTypeRawValue: Int?
    @Persisted var weight: Double?
    @Persisted var wetFeedCalorie: Double?
    @Persisted var dryFeedCalorie: Double?
    @Persisted var dryFeedUnit: Double?
    
    var id: String {
        self._id.stringValue
    }
    
    convenience init(_ result: PetStatus) {
        self.init()
        self.foodTypeRawValue = result.foodType?.rawValue
        self.statusTypeRawValue = result.status?.rawValue
        self.weight = result.weight
        self.wetFeedCalorie = result.wetFeedCalorie
        self.dryFeedCalorie = result.dryFeedCalorie
        self.dryFeedUnit = result.dryFeedUnit
    }
}
