//
//  TextField+Ext.swift
//  Jelly
//
//  Created by CatSlave on 4/20/24.
//

import Foundation
import UIKit

// numberPad Done Button : https://stackoverflow.com/questions/61245897/how-to-add-done-button-on-numberpad-keyboard-for-vpmotpview-in-swift
extension UITextField {
    
    /// Adding a done button on the keyboard
    func addDoneButtonOnKeyboard(batonNumber: Int) {
        let name = batonNumber == 0 ? "다음" : "완료"
        
        let doneToolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50))
        doneToolbar.barStyle = .default

        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let done = UIBarButtonItem(title: name, style: .done, target: self, action: #selector(self.doneButtonAction))

        let items = [flexSpace, done]
        doneToolbar.items = items
        doneToolbar.sizeToFit()

        self.inputAccessoryView = doneToolbar
    }
    
    @objc fileprivate func doneButtonAction() {
        checkEmptyTextField(self.hasText)
    }
    
    fileprivate func checkEmptyTextField(_ hasText: Bool) {
        guard let superVC = self.findViewController(),
              let calorieVC = superVC as? CalorieViewController else { return }
        
        calorieVC.checkEmptyTextField(self, hasText)
    }
}
