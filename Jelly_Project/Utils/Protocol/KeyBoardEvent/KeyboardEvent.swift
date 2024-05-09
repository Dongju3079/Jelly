//
//  Keyboard+Pro.swift
//  Jelly
//
//  Created by CatSlave on 4/19/24.
//

import Foundation
import UIKit

protocol KeyboardEvent where Self: UIViewController {
    var transformView: UIView { get }
    var transformScrollView: UIScrollView { get }
    func setupKeyboardEvent()
}

extension KeyboardEvent where Self: UIViewController {
    func setupKeyboardEvent() {
        
        NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillShowNotification,
                                               object: nil,
                                               queue: .main) { [weak self] notification in
            self?.keyboardWillAppear(notification)
        }
        NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillHideNotification,
                                               object: nil,
                                               queue: .main) { [weak self] notification in
            self?.keyboardWillDisappear(notification)
        }
    }
    
    func removeKeyboardObserver() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    private func keyboardWillAppear(_ sender: Notification) {

        guard let keyboardFrame = sender.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue,
              let currentTextField = UIResponder.currentResponder as? UITextField else { return }
        
        transformScrollView.alwaysBounceVertical = true
        let convertedTextFieldFrame = transformView.convert(currentTextField.frame,
                                                  from: currentTextField.superview)
        let textFieldBottomY = convertedTextFieldFrame.maxY + 30
        let keyboardTopY = keyboardFrame.cgRectValue.origin.y
        
        if textFieldBottomY > keyboardTopY {
            let newFrame = textFieldBottomY - keyboardTopY
            self.transformScrollView.contentOffset.y = newFrame
        }
    }
    
    private func keyboardWillDisappear(_ sender: Notification) {
        transformScrollView.alwaysBounceVertical = false
        
        if self.transformScrollView.contentOffset.y != 0 {
            self.transformScrollView.contentOffset.y = 0
        }
    }
}
