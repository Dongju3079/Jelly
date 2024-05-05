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
    
    enum UsePlace {
        case input
        case output
    }

    // MARK: - Variables
    
    var inputTextFieldEvent: ((Double, FoodType) -> Void)?
    var batonTouchView : CustomTextFieldView?

    var viewType: FoodType?
    
    // MARK: - UI components
    
    private let infoLabel = CustomInfoView()
    
    private lazy var inputTextfield = CustomTextField(viewMode: true,
                                                                       priority: 751).then {
        $0.addTarget(self, action: #selector(inputText(_:)), for: .editingChanged)
    }
    
    let unitButton = CustomButton(type: .empty).then {
        $0.setContentCompressionResistancePriority(.init(750), for: .horizontal)
        $0.setContentHuggingPriority(.defaultHigh, for: .horizontal)
    }
    
    private let nameLabel = UILabel().then {
        $0.textColor = UIColorSet.text(.black)
        $0.font = UIFont(customStyle: .bold, size: 20)
        $0.setContentCompressionResistancePriority(.init(749), for: .horizontal)
        $0.textAlignment = .left
    }

    private lazy var textfieldStackView = UIStackView(arrangedSubviews: [nameLabel, inputTextfield, unitButton]).then {
        $0.alignment = .fill
        $0.axis = .horizontal
        $0.distribution = .fill
        $0.layer.cornerRadius = 20
    }
    
    private lazy var allView = UIStackView(arrangedSubviews: [infoLabel, textfieldStackView]).then {
        $0.alignment = .fill
        $0.spacing = 10
        $0.distribution = .fill
        $0.axis = .vertical
    }
    
    // MARK: - LifeCycle
    
    init(viewType: FoodType? = nil,
         usePlace: UsePlace = .input,
         inputTextFieldData: ((Double, FoodType) -> Void)? = nil,
         batonTouchView: CustomTextFieldView? = nil) {
        
        super.init(frame: .zero)
        self.viewType = viewType
        self.setupAppearance(place: usePlace)
        self.inputTextFieldEvent = inputTextFieldData
        self.inputTextfield.delegate = self
        setupTextFieldBaton(nextField: batonTouchView)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        if unitButton.useType == .numberButton {
            changeButtonImageInsets()
        }
    }
    
    fileprivate func setupTextFieldBaton(nextField: CustomTextFieldView?) {
        if let nextField = nextField {
            self.batonTouchView = nextField
            self.inputTextfield.batonNumber = 0
        } else {
            self.inputTextfield.batonNumber = 1
        }
    }
}

extension CustomTextFieldView: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {

        let aSet = NSCharacterSet(charactersIn:"0123456789").inverted
        let compSepByCharInSet = string.components(separatedBy: aSet)
        let numberFiltered = compSepByCharInSet.joined(separator: "")
        return string == numberFiltered
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
            make.width.equalTo(unitButton.snp.width)
                .priority(.init(749))
        }
    }
    
    
    /// 뷰 아래에 빈공간 추가
    /// - Parameter spacing: 띄울 간격
    func addEmptyView(spacing: Int = 0) {
        let emptyView = UIView().then {
            $0.backgroundColor = .clear
        }
        
        self.allView.addArrangedSubview(emptyView)
        
        emptyView.snp.makeConstraints { make in
            make.height.equalTo(spacing)
        }
    }
}

// MARK: - 커스텀뷰 추가 옵션

extension CustomTextFieldView {
    
    /// 버튼 셋팅 및 사용
    /// - Parameter title: 버튼 타이틀
    func buttonConfiguration(type: CustomButton.UseType = .unitButton,
                             title: String? = nil,
                             scale: UIImage.SymbolScale = .small) {
        
        unitButton.useType = type
        unitButton.setConfiguration(title: title, scale: scale)
        
        if type == .unitButton {
            unitButton.semanticContentAttribute = .forceRightToLeft
            setNameLabelTouch()
        }
        
        unitButton.isEnabled = true
        unitButton.setContentCompressionResistancePriority(.init(752), for: .horizontal)
        unitButton.snp.makeConstraints { make in
            make.width.greaterThanOrEqualTo(80).priority(.init(752))
        }
    }
    
    func setupTextFieldText(text: String?) {
        inputTextfield.text = text
        inputTextfield.isEnabled = false
    }
    
    /// 커스텀 텍스트 뷰 기본생성 메서드
    /// - Parameters:
    ///   - mainTitle: 메인 타이틀
    ///   - subTitle: 서브 타이틀
    func setupTopLabel(mainTitle: String? = nil, subTitle: String? = nil) {
        
        self.infoLabel.setupText(mainTitle, subTitle)
    }

    /// 텍스트 필드 좌측 네임 레이블 사용하기
    /// - Parameter title: 네임 레이블 텍스트
    func setupLeftLabel(_ title: String, _ nonButton: Bool = false) {
        changeStackViewMargins()
        self.nameLabel.text = title
        nameLabel.setContentCompressionResistancePriority(.init(752), for: .horizontal)
        
        if nonButton {
            self.unitButton.snp.makeConstraints { make in
                make.width.equalTo(self.nameLabel.snp.width).priority(752)
            }
        }
    }
    
  
    
    func setupAppearance(place: UsePlace) {
        switch place {
        case .input:
            infoLabel.setupColor(UIColorSet.text(.black))
            inputTextfield.font = UIFont(customStyle: .bold, size: 30)
            textfieldStackView.backgroundColor = .white
        case .output:
            infoLabel.setupColor(UIColorSet.text(.green3))
            inputTextfield.font = UIFont(customStyle: .bold, size: 20)
            textfieldStackView.backgroundColor = UIColorSet.background(.green)
        }
    }
    
    func becomeTextFieldResponder() {
        self.inputTextfield.becomeFirstResponder()
    }
    
    func becomeTextFieldResign() {
        self.inputTextfield.resignFirstResponder()
    }
    
    /// 텍스트 비었는지를 전달
    /// - Returns: Empty(true) / fill(false)
    func checkEmptyTextField() -> Bool {
        return !self.inputTextfield.hasText
    }
    
    func checkInvalidValueTextField() -> Bool {
        guard let value = self.inputTextfield.text,
              let intValue = Int(value) else { return true }

        if intValue == 0 {
            return true
        } else {
            return false
        }
    }
}

// MARK: - Left Label Touch Event

extension CustomTextFieldView {
    
    
    /// 좌측 레이블 X, 우측 버튼 사용시에 활용 (좌측 레이블의 Text는 없지만 Width는 존재(텍스트 필드 중앙화를 위해서))
    fileprivate func setNameLabelTouch() {
        let gesture = UITapGestureRecognizer(target: self, action: #selector(labelGesture(sender:)))
        self.nameLabel.isUserInteractionEnabled = true
        self.nameLabel.addGestureRecognizer(gesture)
    }
    
    @objc func labelGesture(sender: UILabel) {
        self.inputTextfield.becomeFirstResponder()
    }
}

// MARK: - 텍스트필드 이벤트 전달

extension CustomTextFieldView {
    @objc fileprivate func inputText(_ sender: UITextField) {
        guard let viewType = viewType else { return }
        
        if let textData = sender.text,
           let calorie = Double(textData) {
            inputTextFieldEvent?(calorie, viewType)
        } else {
            inputTextFieldEvent?(0, viewType)
        }
    }
}

// MARK: - Helper
extension CustomTextFieldView {
    
    fileprivate func changeButtonImageInsets() {
        let first = unitButton.frame.width
        let second = unitButton.imageView?.image?.size.width
        let result = first - (second ?? 0)
        
        self.unitButton.configuration?.contentInsets = NSDirectionalEdgeInsets(top: 0,
                                                                               leading: result,
                                                                               bottom: 0,
                                                                               trailing: 0)
    }
    
    fileprivate func changeStackViewMargins() {
        textfieldStackView.isLayoutMarginsRelativeArrangement = true
        textfieldStackView.directionalLayoutMargins = NSDirectionalEdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 20)
    }
}


