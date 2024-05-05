//
//  Storyboarded.swift
//  Jelly
//
//  Created by CatSlave on 4/28/24.
//

import Foundation
import UIKit

protocol Storyboarded {
    static func getInstance(_ storyboardName: String?) -> Self?
}
                              
extension Storyboarded where Self: UIViewController {
    
    static func getInstance(_ storyboardName: String? = nil) -> Self? {
        
        let name = storyboardName ?? String(describing: self)
        
        let storyboard = UIStoryboard(name: name, bundle: Bundle.main)
        
        return storyboard.instantiateViewController(identifier: String(describing: name))
    }
}

extension UIViewController : Storyboarded { }



