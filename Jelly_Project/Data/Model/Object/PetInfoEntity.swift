//
//  ObjectInformationEntity.swift
//  Jelly
//
//  Created by CatSlave on 5/4/24.
//

import Foundation
import RealmSwift

class PetInfoEntity: Object {
    @Persisted(primaryKey: true) var _id: ObjectId
    @Persisted var title: String
    @Persisted var date = Date()
    @Persisted var petStatus: List<PetStatusEntity>
    
    var id: String {
        self._id.stringValue
    }
    
    var statusSorted: Results<PetStatusEntity> {
        self.petStatus.sorted(byKeyPath: "createdDate", ascending: false)
    }
    
    convenience init(title: String) {
        self.init()
        self.title = title
    }
}
