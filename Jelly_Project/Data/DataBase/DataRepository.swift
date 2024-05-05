//
//  DataViewModel.swift
//  Jelly
//
//  Created by CatSlave on 3/26/24.
//

import Foundation
import RealmSwift

class DataRepository {
    
    static let shared = DataRepository()
    private init() {}
    
    let realmDB = try! Realm()
    
    var sectionData: Results<ObjectInformationEntity> {
        realmDB.objects(ObjectInformationEntity.self)
    }

    func readSections() -> [ObjectInformation] {
        let sortEntities = sectionData.sorted(byKeyPath: "date", ascending: false)
        
        return sortEntities.map { ObjectInformation(sectionEntity: $0) }
    }
    
    func addNewSection(name: String) -> ObjectInformation {
        let newName = ObjectInformationEntity(title: name)
        
        try! realmDB.write({
            realmDB.add(newName)
        })
        
        return ObjectInformation(sectionEntity: newName)
    }
    
    func deleteSection(sectionEntity: ObjectInformation) {
        
        if let foundSectionEntity = findSection(sectionEntity) {
            try! realmDB.write({
                realmDB.delete(foundSectionEntity)
            })
        }
    }
    
}

// MARK: - 섹션 내부 아이템 관리
extension DataRepository {
    
    
    /// 특정 섹션에 아이템 추가하기
    /// - Parameters:
    ///   - sectionEntity: 추가하고자 하는 섹션
    ///   - newResult: 추가하고자 하는 아이템
    func addNewResult(object: ObjectInformation, detail: DetailInformation) {
        let elementEntity = DetailInformationEntity(detail)
        
        if let foundSectionEntity = findSection(object) {
            
            try! realmDB.write({
                foundSectionEntity.details.append(elementEntity)
            })
        }
    }
    
    
    /// 특정 섹션에 아이템 삭제하기
    /// - Parameters:
    ///   - sectionEntity: 삭제하고자 하는 섹션
    ///   - deleteResult: 삭제하고자 하는 아이템
    /// - Returns: 삭제가 완료된 뒤 섹션배열
    func deleteResultAtSection(sectionEntity: ObjectInformation, deleteResult: DetailInformation) {
        
        if let foundSectionEntity = findSection(sectionEntity),
           let foundResultEntityIndex = foundSectionEntity.details.firstIndex(where: { $0.id == deleteResult.uuid }) {
            
            try! realmDB.write({
                print(#fileID, #function, #line, "-삭제 완료 ")
                foundSectionEntity.details.remove(at: foundResultEntityIndex)
            })
        }
    }
}

extension DataRepository {
    
    
    /// 섹션모델과 같은 섹션엔티티 찾기
    /// - Parameter sectionEntity: 찾고 싶은 섹션
    /// - Returns: 섹션 엔티티
    fileprivate func findSection(_ sectionEntity: ObjectInformation) -> ObjectInformationEntity? {
        let foundSectionEntity = sectionData.filter {
            return $0.id == sectionEntity.uuid
        }.first
        
        return foundSectionEntity
    }
}
