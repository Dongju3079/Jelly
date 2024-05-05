//
//  CustomStackView.swift
//  Jelly
//
//  Created by CatSlave on 4/11/24.
//

import UIKit
import Then
import SnapKit

class CustomStackView: UIStackView {
    
    enum UsePlace {
        case info
        case input
        case output
    }


    init(type: UsePlace,
         views: [UIView],
         outputResult: String? = nil) {
        
        super.init(frame: .zero)
        
        switch type {
        case .info:
            setupInfoType(views)
        case .input:
            setupInputType(views)
        case .output:
            setupOutputType(views, outputResult)
        }
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - info Type
    fileprivate func setupInfoType(_ infoViews: [UIView]) {
        infoViews.forEach({ self.addArrangedSubview($0) })
        
        self.axis = .vertical
        self.spacing = 40
        self.distribution = .fillEqually
        self.alignment = .fill
    }

    
    // MARK: - input Type
    fileprivate func setupInputType(_ inputViews: [UIView]) {
        
        inputViews.forEach({ self.addArrangedSubview($0) })
        
        self.axis = .vertical
        self.spacing = 50
        self.distribution = .fill
        self.alignment = .fill
    }

    
    // MARK: - output Type
    fileprivate func setupOutputType(_ outputViews: [UIView],
                                     _ outputResult: String?) {
        guard let outputResult = outputResult else { return }

        var defaultView = getDefaultOutputViews(outputResult)
        
        let index = defaultView.endIndex-1
        
        defaultView.insert(contentsOf: outputViews, at: index)
        
        defaultView.forEach {
            self.addArrangedSubview($0)
        }
        
        self.axis = .vertical
        self.spacing = 0
        self.isLayoutMarginsRelativeArrangement = true
        self.layoutMargins = UIEdgeInsets(top: 10, left: 10, bottom: 30, right: 10)
        self.layer.cornerRadius = 8
    }
    
    fileprivate func getDefaultOutputViews(_ outputResult: String) -> [UIView] {
        let requiredView = CustomTextFieldView(usePlace: .output).then {
            $0.setupTopLabel(mainTitle: "하루 적정 칼로리")
            $0.setupTextFieldText(text: "\(outputResult) kcal")
            $0.addEmptyView(spacing: 20)
        }
        
        let infoLabel = UILabel().then {
            $0.text = "급여량은 최소 2 ~ 3회에 나눠서 급여를 추천드립니다."
            $0.numberOfLines = 2
            $0.textColor = UIColorSet.text(.green)
            $0.font = UIFont(customStyle: .medium, size: 13)
            $0.textAlignment = .center
        }
        
        return [requiredView, infoLabel]
    }
}
