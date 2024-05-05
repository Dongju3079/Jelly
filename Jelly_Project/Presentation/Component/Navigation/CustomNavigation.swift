//
//  UINavgi+Ext.swift
//  Jelly
//
//  Created by CatSlave on 4/30/24.
//

import Foundation
import UIKit

class CustomNavigation: UINavigationController {
    
    enum ViewControllerCase: String {
        
        case name = "nib_name"
        case food = "nib_food"
        case status = "nib_status"
        case weight = "storyboard_weight"
        case calorie = "storyboard_calorie"
        case result = "storyboard_result"
        
        var vcType: UIViewController.Type {
            switch self {
            case .name:
                NameViewController.self
            case .food:
                FoodTypeViewController.self
            case .status:
                StatusTypeViewController.self
            case .weight:
                WeightViewController.self
            case .calorie:
                CalorieViewController.self
            case .result:
                ResultViewController.self
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func pushToViewController(destinationVCCase: ViewControllerCase) {
        
        var destinationVC: UIViewController?
        
        if destinationVCCase.rawValue.contains("nib") {
            print("👾 테스트 : nib base 👾")
            destinationVC = destinationVCCase.vcType.init()
        } else if destinationVCCase.rawValue.contains("storyboard") {
            print("👾 테스트 : storyboard base 👾")
            destinationVC = destinationVCCase.vcType.getInstance()
        }
        
        guard let destinationVC = destinationVC else { return }
        self.pushViewController(destinationVC, animated: true)
    }
}
