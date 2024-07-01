//
//  PetInfoReactor.swift
//  Jelly_Project
//
//  Created by CatSlave on 7/1/24.
//

import Foundation
import ReactorKit

class PetInfoReactor: Reactor {
    
    enum Action {
        case fetchData
        case checkFirstEntered
        case buttonRadiusUpdate
        case deleteStatus(IndexPath)
    }
    
    enum Mutation {
        case setTodos(_ petDatas: [PetInfo],_ indexSet: IndexSet?,_ isEmpty: Bool?)
        case checkDisplayData(isEmpty: Bool)
        case checkFirstEntered(isFirst: Bool)
        case buttonRadiusUpdate
    }
    
    struct State {
        @Pulse var fetchData: (petDatas: [PetInfo], indexSet: IndexSet?, isEmpty: Bool?)? = nil
        @Pulse var displayDataIsEmpty: Bool = true
        @Pulse var firstEnterCheck: Bool = true
        @Pulse var buttonRadiusUpdate: Void? = nil
    }
    
    var initialState: State = State()
    
    init() {
        action.onNext(.fetchData)
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        
        switch action {
        case .fetchData:
            let petDatas = DataRepository.shared.readSections()
            let fetchData = Observable.just(Mutation.setTodos(petDatas, nil, nil))
            
            let petStatusData = petDatas.filter { !$0.status.isEmpty }
            let checkDisplayData = Observable.just(Mutation.checkDisplayData (isEmpty: petStatusData.isEmpty))
            
            return Observable.concat([fetchData, checkDisplayData])
         
        case .checkFirstEntered:
            
            let enterCheck = BasicUserDefaults.shard.enteredCheck()
            if !enterCheck {
                BasicUserDefaults.shard.firstEnter()
            }
            return Observable.just(Mutation.checkFirstEntered(isFirst: enterCheck))
            
        case .buttonRadiusUpdate:
            return Observable.just(Mutation.buttonRadiusUpdate)
            
        case .deleteStatus(let indexPath):
            guard let fetchData = currentState.fetchData else { return Observable.empty() }
            var petDatas = fetchData.petDatas
            var targetInfo = petDatas[indexPath.section]
            let targetStatus = targetInfo.status[indexPath.row]
//            
            targetInfo.status.removeAll { $0.entityId == targetStatus.entityId }
            petDatas[indexPath.section] = targetInfo
            let indexSet = IndexSet(integer: indexPath.section)
            
            let deletePetStatus = Observable.just(Mutation.setTodos(petDatas, indexSet, targetInfo.status.isEmpty))
            
            let petStatusData = petDatas.filter { !$0.status.isEmpty }
            let checkDisplayData = Observable.just(Mutation.checkDisplayData (isEmpty: petStatusData.isEmpty))
            
            return Observable.concat([deletePetStatus, checkDisplayData])
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        
        switch mutation {
        case .setTodos(let petDatas, let indexSet, let isEmpty):
            newState.fetchData = (petDatas, indexSet, isEmpty)
        case .checkDisplayData(let isEmpty):
            newState.displayDataIsEmpty = !isEmpty
        case .checkFirstEntered(let isEntered):
            newState.firstEnterCheck = isEntered
        case .buttonRadiusUpdate:
            newState.buttonRadiusUpdate = ()
        }
        
        return newState
    }
}
