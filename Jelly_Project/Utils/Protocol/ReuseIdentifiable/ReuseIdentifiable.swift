//
//  Identifiable.swift
//  Jelly
//
//  Created by CatSlave on 4/19/24.
//

import Foundation
import UIKit

// MARK: - identifier
protocol ReuseIdentifiable {
    static var name: String { get }
}

extension ReuseIdentifiable {
    static var name: String {
        return String(describing: Self.self)
    }
}

extension UIView: ReuseIdentifiable { }
extension UIViewController: ReuseIdentifiable { }
