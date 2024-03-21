//
//  UIView+Ext.swift
//  Jelly
//
//  Created by CatSlave on 3/18/24.
//

import Foundation
import UIKit
import Then

extension UIView {
    
    /// addSubview 배열로 하기
    /// - Parameter views: 추가할 [View]
    func addSubviews(_ views: [UIView]) {
        for view in views {
            self.addSubview(view)
        }
    }
}

extension UIStackView {
    
    /// 스택뷰 생성
    /// - Parameters:
    ///   - views: 스택뷰에 넣을 뷰
    ///   - spacing: 각 뷰 사이의 거리
    static func combineInputView(views: [UIView]) -> UIView {
        
        let inputStackView = UIStackView(arrangedSubviews: views).then {
            $0.axis = .vertical
            $0.spacing = 50
            $0.distribution = .fill
            $0.alignment = .fill
        }
        
        return inputStackView
    }
    
    static func combineOutputView(topView: UIView, bottomView: UIView?, adequateCalorie: String?) -> UIStackView {
        
        let requiredView = CustomTextFieldView(userTextField: false).then {
            $0.setting(mainTitle: "하루 적정 칼로리")
            
            // 적정 칼로리 계산로직 후
            $0.inputTextFieldValue = adequateCalorie
        }
        
        let infoLabel = UILabel().then {
            $0.text = "급여량은 최소 2 ~ 3회에 나눠서 급여를 추천드립니다."
            $0.numberOfLines = 2
            $0.textColor = .label
            $0.font = .boldSystemFont(ofSize: 20)
            $0.textAlignment = .left
        }
        
        lazy var labelStackViewForInset = UIStackView(arrangedSubviews: [infoLabel]).then {
            $0.isLayoutMarginsRelativeArrangement = true
            $0.layoutMargins = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        }
        
        let resultView = [requiredView, topView, bottomView, labelStackViewForInset].compactMap { $0 }
        
        lazy var infoStackView = UIStackView(arrangedSubviews: resultView).then {
            $0.axis = .vertical
            $0.spacing = 20
            
            $0.isLayoutMarginsRelativeArrangement = true
            $0.layoutMargins = UIEdgeInsets(top: 10, left: 10, bottom: 30, right: 10)
        }
        
        return infoStackView
    }
    
}


#if DEBUG
import SwiftUI

extension UIView {
    
    private struct ViewRepresentable : UIViewRepresentable {
        
        let uiview : UIView
        
        func updateUIView(_ uiView: UIViewType, context: Context) {
        }
        
        func makeUIView(context: Context) -> some UIView {
            return uiview
        }
        
    }
    func getPreview() -> some View {
        ViewRepresentable(uiview: self)
    }
}


#endif
