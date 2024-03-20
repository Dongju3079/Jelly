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

    
    /// 반려동물 식사 타입이 단일인 경우에 맞춰서 CustomTextFieldView를 생성 및 리턴
    /// - Parameter firstConfiguration: 첫번째 커스텀뷰 구성 (타입, 버튼 이벤트, 텍스트필드 이벤트)
    static func makeSingleView(_ configuration: (CustomType, Bool?, ((String) -> Void)?)) -> UIView {
        
        let singleInput = CustomTextFieldView(type: configuration.0,
                                              onButton: configuration.1,
                                              inputTextFieldData: configuration.2)
        
        return singleInput
    }
    
    /// FoodType(.Mix)인 경우의 스택뷰를 생성
    ///   - Parameter firstConfiguration: 첫번째 커스텀뷰 구성 (타입, 버튼 이벤트, 텍스트필드 이벤트)
    ///   - Parameter secondConfiguration: 두번째 커스텀뷰 구성 (타입, 버튼 이벤트, 텍스트필드 이벤트)
    ///   - Parameter spacing: 스택뷰 요소의 거리
    ///   - Returns: 스택뷰
    static func makeMixView(_ firstConfiguration: (CustomType, Bool?, ((String) -> Void)?),
                            _ secondConfiguration: (CustomType, Bool?, ((String) -> Void)?),
                            _ spacing: CGFloat = 50) -> UIView {
        
        let firstInput = CustomTextFieldView(type: firstConfiguration.0,
                                             onButton: firstConfiguration.1,
                                             inputTextFieldData: firstConfiguration.2)
    
        let secondInput = CustomTextFieldView(type: secondConfiguration.0,
                                              onButton: secondConfiguration.1,
                                              inputTextFieldData: secondConfiguration.2)
        
        let inputStackView = UIStackView(arrangedSubviews: [firstInput, secondInput]).then {
            $0.axis = .vertical
            $0.spacing = spacing
            $0.distribution = .fill
            $0.alignment = .fill
        }
        
        return inputStackView
    }
}

extension UIStackView {
    
    static func makeResultView(_ addView: UIView) -> UIStackView {
        let calorieView = CustomTextFieldView(type: .outputOfType(outputType: .normal))
        
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
        
        lazy var infoStackView = UIStackView(arrangedSubviews: [calorieView, addView, labelStackViewForInset]).then {
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
