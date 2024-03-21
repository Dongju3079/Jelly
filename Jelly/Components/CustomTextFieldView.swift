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

    // MARK: - Variables
    
    var inputTextFieldEvent: ((Double, FoodType) -> Void)?
    
    var inputTextFieldValue: String? = "0.0"{
        didSet {
            inputTextfield.text = inputTextFieldValue
        }
    }
    
    var viewType: FoodType?
    
    // MARK: - UI components
    
    private let infoLabel = CustomInfoView()
    
    private lazy var inputTextfield: UITextField = UITextField().then {
        $0.placeholder = "Kcal"
        $0.textAlignment = .center
        $0.tintColor = .clear
        $0.font = .systemFont(ofSize: 30)
        $0.setContentCompressionResistancePriority(.init(751), for: .horizontal)
        $0.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: $0.frame.height))
        $0.rightView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: $0.frame.height))
        $0.leftViewMode = .always
        $0.rightViewMode = .always
        $0.addTarget(self, action: #selector(inputText(_:)), for: .editingChanged)
    }
    
    let selectButton: UIButton = UIButton().then {
        $0.titleLabel?.font = .boldSystemFont(ofSize: 20)
        $0.setTitleColor(.label, for: .normal)
        $0.tintColor = .systemGray
        $0.isEnabled = false
        $0.setContentCompressionResistancePriority(.init(750), for: .horizontal)
        $0.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        $0.semanticContentAttribute = .forceRightToLeft
        $0.showsMenuAsPrimaryAction = true
    }
    
    private let nameLabel: UILabel = UILabel().then {
        $0.textColor = .label
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
    
    convenience init(viewType: FoodType? = nil,
                     inputTextFieldData: ((Double, FoodType) -> Void)? = nil,
                     userTextField: Bool = true) {
        
        self.init(frame: .zero)
        self.viewType = viewType
        self.inputTextfield.isEnabled = userTextField
        self.inputTextFieldEvent = inputTextFieldData
       
    }
}

// MARK: - 뷰 위치 잡기
extension CustomTextFieldView {
    
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

// MARK: - 커스텀뷰 추가 옵션

extension CustomTextFieldView {
    
    /// 버튼 셋팅 및 사용
    /// - Parameter title: 버튼 타이틀
    func buttonConfiguration(title: String? = nil,
                             scale: UIImage.SymbolScale = .small) {
        
        selectButton.isEnabled = true
        let symbol = UIImage(systemName: "arrowtriangle.down.fill", withConfiguration: UIImage.SymbolConfiguration(scale: scale))
        selectButton.setImage(symbol, for: .normal)
        selectButton.setTitle(title, for: .normal)
        selectButton.setContentCompressionResistancePriority(.init(752), for: .horizontal)
        selectButton.snp.makeConstraints { make in
            make.width.greaterThanOrEqualTo(80).priority(.init(752))
        }
    }

    
    /// 텍스트 필드 좌측 네임 레이블 사용하기
    /// - Parameter title: 네임 레이블 텍스트
    func setupLeftLabel(_ title: String) {
        self.nameLabel.text = title
        nameLabel.setContentCompressionResistancePriority(.init(752), for: .horizontal)
    }
}

// MARK: - 텍스트필드 이벤트 전달

extension CustomTextFieldView {
    @objc fileprivate func inputText(_ sender: UITextField) {
        if let textData = sender.text,
           let calorie = Double(textData),
           let viewType = viewType {
            inputTextFieldEvent?(calorie, viewType)
        }
    }
}


// MARK: - 커스텀뷰 타이틀 설정하기

extension CustomTextFieldView {
    
    /// 커스텀 텍스트 뷰 기본생성 메서드
    /// - Parameters:
    ///   - mainTitle: 최상위 타이틀
    ///   - mainSub: 최상위 서브 타이틀
    ///   - secondTitle: 기본 타이틀
    ///   - secondSub: 기본(서브) 타이틀
    ///   - useButton: 버튼 사용유무
    func setting(mainTitle: String? = nil,
                 mainSub: String? = nil,
                 secondTitle: String? = nil,
                 secondSub: String? = nil) {
        
        self.infoLabel.setupText(mainTitle, mainSub, secondTitle, secondSub)
    }
}

#if DEBUG

import SwiftUI

struct CustomViewTest_Previews: PreviewProvider {
    static var previews: some View {
        CustomTextFieldView()
            .getPreview()
            .frame(width: 350, height: 140)
            .previewLayout(.sizeThatFits)
    }
    
}

#endif
