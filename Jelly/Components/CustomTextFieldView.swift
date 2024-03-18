//
//  StackViewPractice.swift
//  Jelly
//
//  Created by CatSlave on 3/15/24.
//

import UIKit
import SnapKit
import Then

class CustomTextFieldView: UIView {
    
    enum CustomType {
        enum OutputType {
            case normal // 결과
            case nonButton // 좌측 레이블만 있음
            case onButton // 세컨드, 좌측 레이블 + 버튼(이름 X, 이미지만 존재)
        }
        
        case inputOfOneThing(useButton: Bool)
        case inputOfTwoThing(foodType: FoodType)
        case outputOfType(outputType: OutputType)
    }

    // MARK: - UI components
    
    private let infoLabel = CustomInfoView()
    
    private let weightTextfield: UITextField = UITextField().then {
        $0.textAlignment = .center
        $0.tintColor = .clear
        $0.font = .systemFont(ofSize: 30)
        $0.setContentCompressionResistancePriority(.init(750), for: .horizontal)
        $0.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: $0.frame.height))
        $0.rightView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: $0.frame.height))
        $0.leftViewMode = .always
        $0.rightViewMode = .always
    }
    
    let weightButton: UIButton = UIButton().then {
        
        $0.titleLabel?.font = .boldSystemFont(ofSize: 20)
        
        $0.setTitleColor(.black, for: .normal)
        
        let symbol = UIImage(systemName: "arrowtriangle.down.fill", withConfiguration: UIImage.SymbolConfiguration(scale: .small))
        $0.setImage(symbol, for: .normal)
        $0.tintColor = .systemGray
        $0.setContentCompressionResistancePriority(.init(751), for: .horizontal)
        $0.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        $0.semanticContentAttribute = .forceRightToLeft
    }
    
    private let nameLabel: UILabel = UILabel().then {
        $0.textColor = .black
        $0.font = .boldSystemFont(ofSize: 20)
        $0.setContentCompressionResistancePriority(.init(749), for: .horizontal)
        $0.textAlignment = .left
    }
    
    private lazy var textfieldStackView: UIStackView = UIStackView(arrangedSubviews: [nameLabel, weightTextfield, weightButton]).then {
        $0.alignment = .fill
        $0.axis = .horizontal
        $0.distribution = .fill
        $0.backgroundColor = .systemGray2
        $0.layer.cornerRadius = 20
        $0.isLayoutMarginsRelativeArrangement = true
        $0.directionalLayoutMargins = NSDirectionalEdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 20)
    }
    
    private lazy var allView = UIStackView(arrangedSubviews: [infoLabel, textfieldStackView]).then {
        $0.backgroundColor = .clear
        $0.alignment = .leading
        $0.spacing = 10
        $0.distribution = .fill
        $0.axis = .vertical
    }
    
    
    // MARK: - LifeCycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .clear
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

    
    convenience init(type: CustomType) {
        self.init(frame: .zero)
        
        switch type {
            
        case .inputOfOneThing(let useButton) :
            setting(secondTitle: "칼로리", secondSub: "Kcal", useButton: useButton)
            
        case .inputOfTwoThing(let foodType) :
            twoInputSetup(foodType)
            
        case .outputOfType(let outputType):
            resultSetup(outputType)
        }
    }

    // MARK: - UI Setup
    fileprivate func setupUI() {
        self.addSubview(allView)
        
        allView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        textfieldStackView.snp.makeConstraints { make in
            make.width.equalTo(allView.snp.width)
            make.height.equalTo(70)
        }
        
        weightButton.snp.makeConstraints { make in
            make.width.equalTo(100)
        }
        
        nameLabel.snp.makeConstraints { make in
            make.width.equalTo(weightButton.snp.width)
                .priority(.init(749))
        }
    }
    

    
    
    /// nameLabel text 입력하기
    func setupLeftLabel(_ title: String) {
        self.nameLabel.text = title
        nameLabel.setContentCompressionResistancePriority(.init(751), for: .horizontal)
    }
}

// MARK: - 텍스트 필드 타입 정하기
extension CustomTextFieldView {
    
    fileprivate func setting(mainTitle: String? = nil,
                 mainSub: String? = nil,
                 secondTitle: String? = nil,
                 secondSub: String? = nil,
                 useButton: Bool = false) {
        
        self.infoLabel.setupText(mainTitle, mainSub, secondTitle, secondSub)
        
        if useButton {
            self.weightButton.isHidden = !useButton
            weightButton.setTitle("Kg(단위) ", for: .normal)
        }
    }
    
    /// 입력창이 두개 필요할 때
    /// - Parameter foodType: 입력타입
    fileprivate func twoInputSetup(_ foodType: FoodType) {
        switch foodType {
        case .wet:
            setting(mainTitle: "습식",
                    mainSub: "한 캔(포) 당",
                    secondTitle: "칼로리",
                    secondSub: "Kcal")
        default:
            setting(mainTitle: "건식",
                    secondTitle: "칼로리",
                    secondSub: "Kcal",
                    useButton: true)
            
            // 임시
            weightButton.setTitle("Kg(단위) ", for: .normal)
            
        }
    }
    
    
    /// 결과안내 레이블
    /// - Parameter outputType: 결과안내 타입
    fileprivate func resultSetup(_ outputType: CustomTextFieldView.CustomType.OutputType) {
        switch outputType {
        case .normal:
            setting(mainTitle: "하루 적정 칼로리")
        case .nonButton:
            setupLeftLabel("건식")
        case .onButton:
            setting(secondTitle: "1일 권장 급여량", useButton: true)
            setupLeftLabel("습식")
            
        }
    }
    
}


#if DEBUG

import SwiftUI

struct CustomViewTest_Previews: PreviewProvider {
    static var previews: some View {
        CustomTextFieldView(type: .inputOfTwoThing(foodType: .dry))
            .getPreview()
            .frame(width: 350, height: 140)
            .previewLayout(.sizeThatFits)
    }
    
}

#endif








