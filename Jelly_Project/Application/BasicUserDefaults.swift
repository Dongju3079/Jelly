//
//  UserDefaults.swift
//  Jelly
//
//  Created by CatSlave on 5/1/24.
//

import Foundation

class BasicUserDefaults {
    
    enum Key: String {
        case firstEnter
    }
    
    static let shard = BasicUserDefaults()
    private init() {}
    
    func enteredCheck() -> Bool {
        let entered = UserDefaults.standard.bool(forKey: Key.firstEnter.rawValue)

        return entered
    }
    
    func firstEnter() {
        UserDefaults.standard.set(true, forKey: Key.firstEnter.rawValue)
    }
    
    func resetEnter() {
        UserDefaults.standard.set(false, forKey: Key.firstEnter.rawValue)
    }
}
    
    
