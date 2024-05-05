//
//  Double+Ext.swift
//  Jelly
//
//  Created by CatSlave on 4/19/24.
//

import Foundation

extension Double {
    var clean: Double {
        let cutString = String(format: "%.1f", self)
        let value = Double(cutString) ?? 0
        return value
    }
    
    var convertString: String {
        
        return String(lround(self))
    }
}
