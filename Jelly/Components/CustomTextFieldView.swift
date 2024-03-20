//
//  StackViewPractice.swift
//  Jelly
//
//  Created by CatSlave on 3/15/24.
//

import UIKit
import SnapKit
import Then

// MARK: - Button Type
enum CustomType {
    enum OutputType {
        case normal
        case nonButton(showLabel: Bool)
        case onButton
    }
    
    case singleInput(foodType: FoodType)
    case doubleInput(foodType: FoodType)
    case outputOfType(outputType: OutputType)
}

class CustomTextFieldView: UIView {

    // MARK: - Variables
    var inputTextFieldEvent: ((String) -> Void)?
    
    
    // MARK: - UI components
    private let infoLabel = CustomInfoView()
    
    private lazy var inputTextfield: UITextField = UITextField().then {
        $0.textAlignment = .center
        $0.tintColor = .clear
        $0.font = .systemFont(ofSize: 30)
        $0.setContentCompressionResistancePriority(.init(750), for: .horizontal)
        $0.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: $0.frame.height))
        $0.rightView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: $0.frame.height))
        $0.leftViewMode = .always
        $0.rightViewMode = .always
        $0.addTarget(self, action: #selector(inputText(_:)), for: .editingChanged)
    }
    
    let selectButton: UIButton = UIButton().then {
        $0.titleLabel?.font = .boldSystemFont(ofSize: 20)
        $0.setTitleColor(.black, for: .normal)
        $0.tintColor = .systemGray
        $0.isEnabled = false
        $0.setContentCompressionResistancePriority(.init(751), for: .horizontal)
        $0.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        $0.semanticContentAttribute = .forceRightToLeft
        $0.showsMenuAsPrimaryAction = true
        $0.backgroundColor = .systemMint
    }
    
    private let nameLabel: UILabel = UILabel().then {
        $0.textColor = .black
        $0.font = .boldSystemFont(ofSize: 20)
        $0.setContentCompressionResistancePriority(.init(749), for: .horizontal)
        $0.textAlignment = .left
    }
    
    private lazy var textfieldStackView: UIStackView = UIStackView(arrangedSubviews: [nameLabel, inputTextfield, selectButton]).then {
        $0.alignment = .fill
        $0.axis = .horizontal
        $0.distribution = .fill
        $0.backgroundColor = .systemGray2
        $0.layer.cornerRadius = 20
        $0.isLayoutMarginsRelativeArrangement = true
        $0.directionalLayoutMargins = NSDirectionalEdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 20)
    }
    
    private lazy var allView = UIStackView(arrangedSubviews: [infoLabel, textfieldStackView]).then {
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
    
    convenience init(type: CustomType,
                     onButton: Bool? = false,
                     inputTextFieldData: ((String) -> Void)? = nil) {
        
        self.init(frame: .zero)
        self.inputTextFieldEvent = inputTextFieldData
        buttonConfiguration(onButton)
        customViewConfiguration(type)
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

        nameLabel.snp.makeConstraints { make in
            make.width.equalTo(selectButton.snp.width)
                .priority(.init(749))
        }
    }
}

// MARK: - 뷰 구성
extension CustomTextFieldView {
    fileprivate func buttonConfiguration(_ onButton: Bool?) {
        if onButton ?? false {
            selectButton.menu = weightChangeMenu()
            selectButtonActiveSetup()
        } else {
            selectButton.setContentCompressionResistancePriority(.init(749), for: .horizontal)
        }
    }
    
    fileprivate func customViewConfiguration(_ type: CustomType) {
        switch type {
            
        case .singleInput(let foodType) :
            singleInputSetup(foodType)
            
        case .doubleInput(let foodType) :
            doubleInputSetup(foodType)
            
        case .outputOfType(let outputType):
            outputSetup(outputType)
        }
    }
}

// MARK: - 버튼에 사용되는 UIMenu 생성
extension CustomTextFieldView {
    
    fileprivate func weightChangeMenu() -> UIMenu {
        
        return UIMenu(children: [
            UIAction(title: "Kg(단위)", handler: { [weak self] _ in
                self?.selectButton.setTitle("Kg(단위)", for: .normal)
                // VC로 토글 날릴 수 있는 클로저 사용
                
            }),
            UIAction(title: "g(단위)", handler: { [weak self] _ in
                self?.selectButton.setTitle("g(단위)", for: .normal)
                // VC로 토글 날릴 수 있는 클로저 사용
                
            })
        ])
    }
    
    fileprivate func amountChangeMenu() -> UIMenu {
        
        return UIMenu()
    }
}

// MARK: - 텍스트필드 이벤트 전달
extension CustomTextFieldView {
    @objc fileprivate func inputText(_ sender: UITextField) {
        if let textData = sender.text {
            inputTextFieldEvent?(textData)
        }
    }
}


// MARK: - 텍스트 필드 타입 설정
extension CustomTextFieldView {
    
    
    /// 버튼 활성화
    fileprivate func selectButtonActiveSetup() {
        let symbol = UIImage(systemName: "arrowtriangle.down.fill", withConfiguration: UIImage.SymbolConfiguration(scale: .small))
        selectButton.setImage(symbol, for: .normal)
        selectButton.isEnabled = true
    }
    
    /// 커스텀 텍스트 뷰 기본생성 메서드
    /// - Parameters:
    ///   - mainTitle: 최상위 타이틀
    ///   - mainSub: 최상위 서브 타이틀
    ///   - secondTitle: 기본 타이틀
    ///   - secondSub: 기본(서브) 타이틀
    ///   - useButton: 버튼 사용유무
    fileprivate func setting(mainTitle: String? = nil,
                 mainSub: String? = nil,
                 secondTitle: String? = nil,
                 secondSub: String? = nil) {
        
        self.infoLabel.setupText(mainTitle, mainSub, secondTitle, secondSub)
    }
    
    
    
    /// 입력창이 한개 필요할 때
    /// - Parameter foodType: 입력타입
    fileprivate func singleInputSetup(_ foodType: FoodType) {
        setting(mainTitle: "칼로리", mainSub: "Kcal")
        
        if foodType == .dry {
            selectButton.setTitle("g(단위)", for: .normal)
        }
    }
    
    /// 입력창이 두개 필요할 때
    /// - Parameter foodType: 입력타입
    fileprivate func doubleInputSetup(_ foodType: FoodType) {
        switch foodType {
        case .wet:
            setting(mainTitle: "습식",
                    mainSub: "한 캔 기준",
                    secondTitle: "칼로리",
                    secondSub: "Kcal")
        default:
            setting(mainTitle: "건식",
                    secondTitle: "칼로리",
                    secondSub: "Kcal")
            
            selectButton.setTitle("g(단위)", for: .normal)
        }
    }
    
    
    /// 결과안내 레이블
    /// - Parameter outputType: 결과안내 타입
    fileprivate func outputSetup(_ outputType: CustomType.OutputType) {
        switch outputType {
        case .normal:
            setting(mainTitle: "하루 적정 칼로리")
        case .nonButton(let showLabel):
            if showLabel {
                setupLeftLabel("건식")
            } else {
                setting(mainTitle: "1일 권장 급여량")
            }
        case .onButton:
            setting(mainTitle: "1일 권장 급여량")
            setupLeftLabel("습식")
            selectButton.setTitle("수량 ", for: .normal)
        }
    }
    
    /// nameLabel text 입력하기
    fileprivate func setupLeftLabel(_ title: String) {
        self.nameLabel.text = title
        nameLabel.setContentCompressionResistancePriority(.init(751), for: .horizontal)
    }
}







#if DEBUG

import SwiftUI

struct CustomViewTest_Previews: PreviewProvider {
    static var previews: some View {
        CustomTextFieldView(type: .outputOfType(outputType: .onButton))
            .getPreview()
            .frame(width: 350, height: 140)
            .previewLayout(.sizeThatFits)
    }
    
}

#endif
