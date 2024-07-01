//
//  Object.swift
//  Jelly
//
//  Created by CatSlave on 5/4/24.
//
import RxDataSources
import Foundation

struct PetInfo: Hashable, Selectable {
    
    var uuid: String?
    var name: String
    var status: [Item] = []
    var date = Date()
    
    init(sectionEntity: PetInfoEntity) {
        self.uuid = sectionEntity.id
        self.name = sectionEntity.title
        self.date = sectionEntity.date
        readMemos(entity: Array(sectionEntity.statusSorted))
    }

    mutating private func readMemos(entity : [PetStatusEntity])  {
    
        self.status = entity.map { PetStatus(memoEntity: $0) }
    }
    
    func checkEmptyStatus() -> Bool {
        return status.isEmpty
    }
}

extension PetInfo: AnimatableSectionModelType {
    typealias Item = PetStatus
    
    var items: [PetStatus] {
        return status
    }
    
    var identity: String {
        return name
    }
    
    init(original: PetInfo, items: [PetStatus]) {
        self = original
        self.status = items
    }
    
    
}

