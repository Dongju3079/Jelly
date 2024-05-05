//
//  UIMenu+Ext.swift
//  Jelly
//
//  Created by CatSlave on 4/30/24.
//

import Foundation
import UIKit

extension UIMenu {
    
    static func setupMenu(currentView: CustomTextFieldView,
                               linkView: CustomTextFieldView,
                               dataManager: DataManager) -> Self? {
        let maxCount = dataManager.wetFeedMaxCount()
        
        if maxCount >= 1 {
            let currentMenuCount = 0...maxCount
            
            let actions = currentMenuCount.map { count in
                UIAction(title: "\(count)캔 급여") { _ in
                    currentView.setupTextFieldText(text: "\(count) 캔")
                    linkView.setupTextFieldText(text: dataManager.dryFeedAmountOfWetFeedCount(count))
                }
            }
            
            let menu = UIMenu(title: "습식 갯수", children: actions)
            
            return menu as? Self
        } else {
            return nil
        }
    }
}
