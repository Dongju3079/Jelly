//
//  Model.swift
//  Jelly
//
//  Created by CatSlave on 3/15/24.
//

import Foundation

enum FoodType: String, CaseIterable {
    case wet = "습식"
    case dry = "건식"
    case mix = "혼합"
}

enum StatusType: String, CaseIterable {
    case growthPeriod = "성장기"
    case oldAge = "고령묘"
    case obesity = "비만"
    case underWeight = "저체중"
    case neutered = "중성화 O"
    case notNeutered = "중성화 X"
}
