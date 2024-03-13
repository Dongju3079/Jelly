//
//  resultModel.swift
//  Jelly
//
//  Created by CatSlave on 3/13/24.
//

import Foundation

struct ResultSection {
    var name: String
    var row: [ResultModel]
}

struct ResultModel {
    var date: Date = Date()
}
