//
//  ObjectInformationEntity.swift
//  Jelly
//
//  Created by CatSlave on 5/4/24.
//

import Foundation
import RealmSwift

class ObjectInformationEntity: Object {
    @Persisted(primaryKey: true) var _id: ObjectId
    @Persisted var title: String
    @Persisted var date = Date()
    @Persisted var details: List<DetailInformationEntity>
    
    var id: String {
        self._id.stringValue
    }
    
    var detailsSorted: Results<DetailInformationEntity> {
        self.details.sorted(byKeyPath: "createdDate", ascending: false)
    }
    
    convenience init(title: String) {
        self.init()
        self.title = title
    }
}
