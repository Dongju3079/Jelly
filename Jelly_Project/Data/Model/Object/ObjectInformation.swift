//
//  Object.swift
//  Jelly
//
//  Created by CatSlave on 5/4/24.
//

import Foundation

class ObjectInformation: NSObject, Selectable {
    
    var uuid: String?
    var title: String = "이름없음"
    var date = Date()
    var data: [DetailInformation] = []
    
    init(sectionEntity: ObjectInformationEntity) {
        super.init()
        self.uuid = sectionEntity.id
        self.title = sectionEntity.title
        self.date = sectionEntity.date
        readMemos(entity: Array(sectionEntity.detailsSorted))
    }

    fileprivate func readMemos(entity : [DetailInformationEntity])  {
    
        self.data = entity.map { DetailInformation(memoEntity: $0) }
    }
    
    static func == (lhs: ObjectInformation, rhs: ObjectInformation) -> Bool {
            return lhs.uuid == rhs.uuid
    }
    
}
