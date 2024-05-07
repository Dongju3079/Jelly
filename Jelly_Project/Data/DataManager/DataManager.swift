//
//  DataManager.swift
//  Jelly
//
//  Created by CatSlave on 4/30/24.
// Test

import Foundation

enum EmptyError: Error {
    case notEmpty
}

class DataManager {
    
    static let shared = DataManager()
    private let dataRepository = DataRepository.shared
    var currentObjectInfo: ObjectInformation?
    var currentDetailInfo: DetailInformation?
    var objects : [ObjectInformation] = []

    private init() { }

}

// MARK: - 데이터 처리
extension DataManager {
    
    func readData() {
        objects = dataRepository.readSections()
    }
    
    func removeDataToDB(_ index: IndexPath) -> DetailInformation {
        let object = objects[index.section]
        let item = object.data[index.row]
        
        self.objects[index.section].data.removeAll {
            $0.uuid == item.uuid
        }
        
        self.dataRepository.deleteResultAtSection(sectionEntity: object, deleteResult: item)
        
        return item
    }
    
    func saveDataToDB() {
        guard let object = currentObjectInfo,
              let detail = currentDetailInfo else { return }
        
        DataRepository.shared.addNewResult(object: object, detail: detail)
    }
    
    func makeNewObjectToDB(_ objectName: String) -> ObjectInformation {
        let object = dataRepository.addNewSection(name: objectName)
        
        self.objects.insert(object, at: 0)
        
        return object
    }
    
    func deleteObjectToDB(_ object: ObjectInformation) {
        self.objects.removeAll {
            $0 == object
        }
        
        dataRepository.deleteSection(sectionEntity: object)
    }
}

// MARK: - 데이터 체크
extension DataManager {
    
    func checkObjectDataEmpty() -> Bool {
        return self.objects.isEmpty
    }
    
    func checkDetailDataEmpty() throws  {
        
        return try objects.forEach {
            if !$0.data.isEmpty {
                throw EmptyError.notEmpty
            }
        }
    }
    
    func checkDetailCountToObject(_ section: Int) -> Bool {
        let object = objects[section]
        return object.data.isEmpty
    }
    
    func checkSameObject(title: String) -> Bool {
        return objects.contains { $0.title == title }
    }
}

// MARK: - 화면별 데이터 설정
extension DataManager {
    
    func setCurrentData(index: IndexPath) {
        currentObjectInfo = objects[index.section]
        currentDetailInfo = currentObjectInfo?.data[index.row]
    }
    
    func makeDetailToObject(index: IndexPath) {
        currentObjectInfo = objects[index.item]
        currentDetailInfo = DetailInformation()
    }
}


// MARK: - ResultViewController에서 사용되는 칼로리 로직
extension DataManager {
    
    func wetFeedMaxCount() -> Int {
        guard let currentDetailInfo = currentDetailInfo else { return 0 }
        return currentDetailInfo.maxWetFeedCount()
    }

    func adequateCalorie() -> String? {
        guard let adequate = currentDetailInfo?.adequateCalorie().convertString else { return nil }
        return adequate
    }
    
    func calculateAmount() -> String? {
        
        switch currentDetailInfo?.foodType {
        case .wet, .dry:
            return amountOfFeed()
        case .mix:
            return dryFeedAmountOfWetFeedCount(1)
        case nil:
            return nil
        }
    }
    
    func amountOfFeed() -> String? {
        guard let detailInfo = currentDetailInfo else { return nil }
        let adequateCalorie = detailInfo.adequateCalorie()
        
        switch currentDetailInfo?.foodType {
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
        guard let detailInfo = currentDetailInfo,
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
