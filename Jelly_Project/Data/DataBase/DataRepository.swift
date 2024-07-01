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
    
    var sectionData: Results<PetInfoEntity> {
        realmDB.objects(PetInfoEntity.self)
    }

    func readSections() -> [PetInfo] {
        let sortEntities = sectionData.sorted(byKeyPath: "date", ascending: false)
        
        return sortEntities.map { PetInfo(sectionEntity: $0) }
    }
    
    func addPetInfo(name: String) -> PetInfo {
        let newName = PetInfoEntity(title: name)
        
        try! realmDB.write({
            realmDB.add(newName)
        })
        
        return PetInfo(sectionEntity: newName)
    }
    
    func deleteSection(sectionEntity: PetInfo) {
        
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
    ///   - petInfo: 상태를 추가하고자 하는 펫
    ///   - status: 펫 상태
    func addNewResult(_ petInfo: PetInfo,_ status: PetStatus) {
        let elementEntity = PetStatusEntity(status)
        
        if let foundSectionEntity = findSection(petInfo) {
            
            try! realmDB.write({
                foundSectionEntity.petStatus.append(elementEntity)
            })
        }
    }
    
    
    /// 특정 섹션에 아이템 삭제하기
    /// - Parameters:
    ///   - sectionEntity: 삭제하고자 하는 섹션
    ///   - deleteResult: 삭제하고자 하는 아이템
    /// - Returns: 삭제가 완료된 뒤 섹션배열
    func deleteResultAtSection(sectionEntity: PetInfo, deleteResult: PetStatus) {
        
        if let foundSectionEntity = findSection(sectionEntity),
           let foundResultEntityIndex = foundSectionEntity.petStatus.firstIndex(where: { $0.id == deleteResult.entityId }) {
            
            try! realmDB.write({
                print(#fileID, #function, #line, "-삭제 완료 ")
                foundSectionEntity.petStatus.remove(at: foundResultEntityIndex)
            })
        }
    }
}

extension DataRepository {
    
    
    /// 섹션모델과 같은 섹션엔티티 찾기
    /// - Parameter sectionEntity: 찾고 싶은 섹션
    /// - Returns: 섹션 엔티티
    fileprivate func findSection(_ sectionEntity: PetInfo) -> PetInfoEntity? {
        let foundSectionEntity = sectionData.filter {
            return $0.id == sectionEntity.uuid
        }.first
        
        return foundSectionEntity
    }
}
