//
//  CustomInfoView.swift
//  Jelly
//
//  Created by CatSlave on 3/18/24.
//

import UIKit
import SnapKit
import Then

class CustomInfoView: UIView {
    
    private let mainTitle = UILabel().then {
        $0.font = UIFont(customStyle: .bold, size: 20)
        $0.setContentHuggingPriority(.defaultLow, for: .horizontal)
    }

    private let subTitle = UILabel().then {
        $0.font = UIFont(customStyle: .medium, size: 15)
        $0.textColor = UIColorSet.text(.green2)
        $0.setContentHuggingPriority(.defaultHigh, for: .horizontal)
    }
    
    private lazy var titleStackView = UIStackView(arrangedSubviews: [mainTitle, subTitle]).then {
        $0.axis = .horizontal
        $0.alignment = .bottom
        $0.distribution = .fill
        $0.spacing = 0
        $0.isLayoutMarginsRelativeArrangement = true
        $0.directionalLayoutMargins = NSDirectionalEdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 10)
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.configuration()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate func configuration() {
        self.addSubview(titleStackView)
        
        titleStackView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}

// MARK: - 외부 설정
extension CustomInfoView {
    
    /// Text Setup
    /// - Parameters:
    ///   - mainTitle: 왼쪽 타이틀
    ///   - subTitle: 오른쪽 타이틀
    func setupText(_ mainTitle: String?,
                     _ subTitle: String?) {
        
        self.mainTitle.text = mainTitle
        self.subTitle.text = subTitle
    }
    
    func setupColor(_ color: UIColor) {
        self.mainTitle.textColor = color
    }
}
