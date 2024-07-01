//
//  DataManager.swift
//  Jelly
//
//  Created by CatSlave on 4/30/24.
// Test

import Foundation
import RxSwift
import RxRelay

enum EmptyError: Error {
    case notEmpty
}

class DataManager {
    
    static let shared = DataManager()
    private let dataRepository = DataRepository.shared
    
    var testRx: BehaviorRelay<([PetInfo], Int?, Bool?)> = .init(value: ([], nil, nil))
    
    var petInfos : [PetInfo] = []
    
    var currentPetInfo: PetInfo?
    
    var currentPetStatus: PetStatus?

    private init() { }

}

// MARK: - 데이터 처리
extension DataManager {
    
    func readData() {
        petInfos = dataRepository.readSections()
        print("테스트 2 : 데이터 전달  /  count : \(petInfos.count)")
        
        testRx.accept((petInfos, nil, nil))
    }
    
    func removeDataToDB(_ index: IndexPath) -> PetStatus {
        let object = petInfos[index.section]
        let item = object.status[index.row]
        
        self.petInfos[index.section].status.removeAll {
            $0.entityId == item.entityId
        }
        
        let filterStatus = self.testRx.value.0.map { petInfo in
            var info = petInfo
            info.status.removeAll(where: { status in
                status.entityId == item.entityId
            })
            return info
        }
        
        let isEmpty = filterStatus[index.section].status.isEmpty
        
        testRx.accept((filterStatus, index.section, isEmpty))
        return item
    }
    
    func saveDataToDB() {
        guard let petInfo = currentPetInfo,
              let petStatus = currentPetStatus else { return }
        
        DataRepository.shared.addNewResult(petInfo, petStatus)
    }
    
    func makePetInfo(_ petName: String) -> PetInfo {
        let petInfo = dataRepository.addPetInfo(name: petName)
        
        self.petInfos.insert(petInfo, at: 0)
        
        return petInfo
    }
    
    func deleteObjectToDB(_ object: PetInfo) {
        self.petInfos.removeAll {
            $0 == object
        }
        
        dataRepository.deleteSection(sectionEntity: object)
    }
}

// MARK: - 데이터 체크
extension DataManager {
    
    func checkPetInfoDataEmpty() -> Bool {
        return self.petInfos.isEmpty
    }
    
    func checkDisplayDataEmpty() -> Bool {
        let petStatusData = petInfos.filter { !$0.status.isEmpty }
        
        return petStatusData.isEmpty
    }
    
    func checkPetStatusIsEmpty(_ section: Int) -> Bool {
        let object = petInfos[section]
        return object.status.isEmpty
    }
    
    func checkSameObject(title: String) -> Bool {
        return petInfos.contains { $0.name == title }
    }
}

// MARK: - 화면별 데이터 설정
extension DataManager {
    
    func setCurrentData(index: IndexPath) {
        currentPetInfo = petInfos[index.section]
        currentPetStatus = currentPetInfo?.status[index.row]
    }
    
    func makeDetailToObject(index: IndexPath) {
        currentPetInfo = petInfos[index.item]
        currentPetStatus = PetStatus()
    }
}


// MARK: - ResultViewController에서 사용되는 칼로리 로직
extension DataManager {
    
    func wetFeedMaxCount() -> Int {
        guard let currentDetailInfo = currentPetStatus else { return 0 }
        return currentDetailInfo.maxWetFeedCount()
    }

    func adequateCalorie() -> String? {
        guard let adequate = currentPetStatus?.adequateCalorie().convertString else { return nil }
        return adequate
    }
    
    func calculateAmount() -> String? {
        
        switch currentPetStatus?.foodType {
        case .wet, .dry:
            return amountOfFeed()
        case .mix:
            return dryFeedAmountOfWetFeedCount(1)
        case nil:
            return nil
        }
    }
    
    func amountOfFeed() -> String? {
        guard let detailInfo = currentPetStatus else { return nil }
        let adequateCalorie = detailInfo.adequateCalorie()
        
        switch currentPetStatus?.foodType {
        case .wet:
            let feedCalorie = detailInfo.wetFeedCalorie ?? 0.0
            return (adequateCalorie / feedCalorie).convertString + " 캔"
        case .dry:
            let feedCalorie = detailInfo.dryFeedConvertOfUnit()
            return (adequateCalorie / feedCalorie).convertString + " g"
        default:
            return nil
        }
    }
    
    func dryFeedAmountOfWetFeedCount(_ count: Int) -> String? {
        guard let detailInfo = currentPetStatus,
              let wetFeedCalorie = detailInfo.wetFeedCalorie  else { return nil }
        
        let dryFeedOfUnit = detailInfo.dryFeedConvertOfUnit()
        
        let adequateCalorie = detailInfo.adequateCalorie()
        let allottedWetFeed = wetFeedCalorie * Double(count)
        let allottedDryFeed = adequateCalorie - allottedWetFeed

        if allottedDryFeed > dryFeedOfUnit {
            return (allottedDryFeed / dryFeedOfUnit).convertString + " g"
        } else {
            return "0 g"
        }
    }
}

