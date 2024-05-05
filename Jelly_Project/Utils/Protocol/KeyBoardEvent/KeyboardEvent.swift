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

        print(#fileID, #function, #line, "- ")
        guard let keyboardFrame = sender.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue,
              let currentTextField = UIResponder.currentResponder as? UITextField else { return }
        
        // frame : 뷰의 상위 뷰(SuperView) 좌표계에 대한 뷰의 위치 (x, y) 및 크기(width, height)
        // bounds : 자체 좌표계의 대한 뷰의 위치 (x, y) 및 크기
        // convert (매개변수 : (rect: 얻고자 하는 View의 Frame, from  현재 frame의 기준이 되는 View)
        // result : 현재 뷰에서 원하는 뷰의 위치
        let convertedTextFieldFrame = transformView.convert(currentTextField.frame,
                                                  from: currentTextField.superview)

        // result : 타겟뷰의 최하단 Y 위치 (+ 수치 : 임계값)
        let textFieldBottomY = convertedTextFieldFrame.maxY + 15
        
        // result : 키보드 최상단 Y 위치
        let keyboardTopY = keyboardFrame.cgRectValue.origin.y
        
        print("테스트 convertedTextFieldFrame : \(textFieldBottomY)")
        print("테스트 textFieldBottomY : \(textFieldBottomY)")
        print("테스트 keyboardTopY : \(keyboardTopY)")

        DispatchQueue.main.async {
            UIView.animate(withDuration: 0.3) {
                
                // 키보드의 위치가 타겟뷰의 최하단 Y를 넘어선다면
                if textFieldBottomY > keyboardTopY {
                    
                    // 넘어선 만큼의 공간
                    let newFrame = textFieldBottomY - keyboardTopY
             
                    // newFrame만큼 스크롤뷰를 올린다.
                    self.transformScrollView.contentOffset.y = newFrame
                }
            }
        }
        
    }
    
    private func keyboardWillDisappear(_ sender: Notification) {
        
        if transformScrollView.contentOffset.y != 0 {
            
            transformScrollView.contentOffset.y = 0
        }
    }
}
