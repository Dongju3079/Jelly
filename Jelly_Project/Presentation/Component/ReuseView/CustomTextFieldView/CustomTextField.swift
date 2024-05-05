//
//  CustomTextField.swift
//  Jelly
//
//  Created by CatSlave on 4/5/24.
//

import UIKit

class CustomTextField: UITextField {
        
    var batonNumber: Int? {
        didSet {
            guard let batonNumber = batonNumber else { return }
            self.addDoneButtonOnKeyboard(batonNumber: batonNumber)
        }
    }
    
    init(viewMode: Bool = false,
         priority: Float?) {
        
        super.init(frame: .zero)
        self.configuration()
        self.setViewMode(isEnabled: viewMode)
        self.setCompressionPriorityForHorizontal(priority: priority)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate func configuration() {
        self.textAlignment = .center
        self.tintColor = UIColor.gray
        self.textColor = UIColorSet.text(.black)
        self.keyboardType = .numberPad
    }
    
    fileprivate func setViewMode(isEnabled: Bool) {
        if isEnabled {
            self.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: self.frame.height))
            self.rightView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: self.frame.height))
            self.leftViewMode = .always
            self.rightViewMode = .always
        }
    }
    
    fileprivate func setCompressionPriorityForHorizontal(priority: Float?) {
        guard let priority = priority else { return }
        
        self.setContentCompressionResistancePriority(.init(priority), for: .horizontal)
    }
    
}
