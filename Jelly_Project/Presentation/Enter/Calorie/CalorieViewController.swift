//
//  CalorieViewController.swift
//  Jelly
//
//  Created by CatSlave on 3/15/24.
//

import UIKit
import SnapKit

class CalorieViewController: UIViewController, KeyboardEvent {
    
    // MARK: - Variables
    var transformScrollView: UIScrollView { return self.inputScrollView }
    var transformView: UIView { return self.view }

    private var responderTextField: CustomTextFieldView?
    private var currentTextField: [CustomTextFieldView] = []
    
    private let dataManager = DataManager.shared
        
    // MARK: - UI components
    

    @IBOutlet weak var commonView: CommonView!
    @IBOutlet weak var borderView: UIView!
    @IBOutlet weak var inputScrollView: UIScrollView!
    @IBOutlet weak var inputStackView: UIStackView!
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupGesture()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupKeyboardEvent()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        removeKeyboardObserver()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        guard let responderTextField = responderTextField else { return }
        responderTextField.becomeTextFieldResponder()
    }
    
    // MARK: - UI Setup
    
    fileprivate func setupUI() {
        self.title = "칼로리 입력"
        setCommonView(.calorie)
        setupNaviItem()
        createTypeView()
    }
    
    fileprivate func setCommonView(_ enterType: EnterType) {
        self.commonView.configuration(enterType: enterType)
    }
    
    /// 타입에 따라서 뷰 생성
    /// - Parameter elements: 반려동물 식사 타입
    fileprivate func createTypeView() {
        guard let detailInfo = dataManager.currentDetailInfo,
              let foodType = detailInfo.foodType else { return }
        
        commonView.setCalorieViewInfoLabel(foodType)
        
        switch foodType {
        case .wet:
            makeWetTypeView()
            
        case .dry:
    
            makeDryTypeView()
            
        case .mix:
            
            makeMixTypeView()
        }
    }
    
    fileprivate func setupNaviItem() {
        self.navigationItem.leftBarButtonItem = .getItem(mode: .left, target: self, action: #selector(popViewController))
        self.navigationItem.rightBarButtonItem = .getItem(mode: .right, target: self, action: #selector(completeAction))
    }
    
    fileprivate func addViewAtInputStackView(inputView: UIView,
                                             responderView: CustomTextFieldView) {
        
        self.inputStackView.addArrangedSubview(inputView)
        self.responderTextField = responderView
    }
    
    // MARK: - 빈 공간 터치시 키보드 내리기
    fileprivate func setupGesture() {
        let gesture = UITapGestureRecognizer(target: self, action: #selector(endEditAction))
        
        // view에 제스처를 먼저 적용한 경우 정상적으로 적용이 되지 않음 (이유는 X)
        self.inputStackView.addGestureRecognizer(gesture)
        self.view.addGestureRecognizer(gesture)
    }
    
    @objc fileprivate func endEditAction() {
        self.view.endEditing(true)
    }
    
    // MARK: - 화면이동
    @objc fileprivate func popViewController() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc fileprivate func completeAction() {
        if checkInputValue() {
            resetGlobalFigure()
            guard let navigation = self.navigationController as? CustomNavigation else { return }
            dataManager.saveDataToDB()
            navigation.pushToViewController(destinationVCCase: .result)
        }
    }
    
    fileprivate func resetGlobalFigure() {
        StatusTypeViewController.resetReuseCount()
        CustomProgressBar.resetGauge()
    }
}


// MARK: - 타입에 맞춰서 뷰 생성하기
extension CalorieViewController {
    
    fileprivate func makeWetTypeView() {
        _ = CustomTextFieldView(viewType: .wet,
                                inputTextFieldData: insertCalorie(calorie:foodType:)).then {
            $0.setupTopLabel(mainTitle: "습식", subTitle: "칼로리(Kcal)")
            addViewAtInputStackView(inputView: $0, responderView: $0)
            currentTextField.append($0)
        }
    }
    
    fileprivate func makeDryTypeView() {
        _ = CustomTextFieldView(viewType: .dry,
                                inputTextFieldData: insertCalorie(calorie:foodType:)).then {
            $0.buttonConfiguration(type: .unitButton, title: "Kg(단위) ")
            $0.unitButton.menu = setupMenu($0.unitButton)
            $0.setupTopLabel(mainTitle: "건식", subTitle: "칼로리(Kcal)")
            addViewAtInputStackView(inputView: $0, responderView: $0)
            currentTextField.append($0)
        }
    }
    
    fileprivate func makeMixTypeView() {
        let dryType = CustomTextFieldView(viewType: .dry,
                                          inputTextFieldData: insertCalorie(calorie:foodType:)).then {
            $0.buttonConfiguration(type: .unitButton, title: "Kg(단위) ")
            $0.unitButton.menu = setupMenu($0.unitButton)
            $0.setupTopLabel(mainTitle: "건식", subTitle: "칼로리(Kcal)")
        }
        
        let wetType = CustomTextFieldView(viewType: .wet,
                                          inputTextFieldData: insertCalorie(calorie:foodType:),
                                          batonTouchView: dryType).then {
            $0.setupTopLabel(mainTitle: "습식", subTitle: "칼로리(Kcal)")
        }
        
        let views = [wetType, dryType]
        
        currentTextField.append(contentsOf: views)
        
        _ = CustomStackView(type: .input,
                            views: views).then({
            addViewAtInputStackView(inputView: $0, responderView: wetType)
        })
    }
}

// MARK: - 메뉴 셋팅
extension CalorieViewController {
    
    /// FoodType 중 .dry인 경우 사료 칼로리의 단위를 Kg, g 중 택 1
    /// - Returns: 메뉴
    fileprivate func setupMenu(_ target: UIButton) -> UIMenu {
        
        let menu = UIMenu(title: "단위를 선택하세요.",children: [
            UIAction(title: "Kg(단위)", handler: { _ in
                target.setTitle("Kg(단위) ", for: .normal)
                
                self.dataManager.currentDetailInfo?.dryFeedUnit = 1_000.0
            }),
            UIAction(title: "g(단위)", handler: { _ in
                target.setTitle("g(단위) ", for: .normal)
                self.dataManager.currentDetailInfo?.dryFeedUnit = 1.0
            })
        ])
        
        return menu
    }
}

// MARK: - 텍스트필드 이벤트
extension CalorieViewController {
    
    /// 습식, 건식에 맞춰서 데이터에 입력
    /// - Parameters:
    ///   - calorie: 먹이 칼로리
    ///   - foodType: 먹이 타입
    fileprivate func insertCalorie(calorie: Double, foodType: FoodType) {
        
        switch foodType {
        case .wet:
            self.dataManager.currentDetailInfo?.wetFeedCalorie = calorie
        case .dry:
            self.dataManager.currentDetailInfo?.dryFeedCalorie = calorie
        case .mix:
            break
        }
    }
}

// MARK: - 입력 값 필터링

#warning("재사용 가능한 부분")
extension CalorieViewController {
    
    fileprivate func checkInputValue() -> Bool {
        return checkTextFieldHasText() && checkValidCalorie()
    }
    
    fileprivate func checkTextFieldHasText() -> Bool {
        self.view.endEditing(true)
        let emptyTextField = currentTextField.filter { $0.checkEmptyTextField() }
        
        if !emptyTextField.isEmpty  {
            self.view.endEditing(true)
            checkEmptyItemAlert(emptyView: emptyTextField.first)
            return false
        } else {
            return true
        }
    }
    
    fileprivate func checkValidCalorie() -> Bool {
        self.view.endEditing(true)
        let invalidValueTextField = currentTextField.filter { $0.checkInvalidValueTextField() }
        
        if !invalidValueTextField.isEmpty {
            checkInvalidItemAlert(emptyView: invalidValueTextField.first)
            return false
        } else{
            return true
        }
    }
}

// MARK: - Alert

extension CalorieViewController {
    
    fileprivate func checkEmptyItemAlert(emptyView: CustomTextFieldView?) {
        AlertManager.shared.defaultAlert(target: self,
                                         title: nil,
                                         message: "빈 항목이 있습니다.",
                                         style: .alert) { _ in
            
            emptyView?.becomeTextFieldResponder()
        }
    }
    
    fileprivate func checkInvalidItemAlert(emptyView: CustomTextFieldView?) {
        AlertManager.shared.defaultAlert(target: self,
                                         title: nil,
                                         message: "올바르지 않은 값입니다.",
                                         style: .alert) { _ in
            emptyView?.becomeTextFieldResponder()
        }
    }
    
    fileprivate func emptyTextFieldAlert(_ textField: UITextField) {
        AlertManager.shared.defaultAlert(target: self,
                                         title: nil,
                                         message: "입력된 값이 없습니다.",
                                         style: .alert) { _ in
            textField.becomeFirstResponder()
        }
    }
}

// MARK: - Helper
extension CalorieViewController {
    fileprivate func findEmptyTextField() -> CustomTextFieldView? {
        return currentTextField.filter({ $0.checkEmptyTextField() }).first
    }
}

// MARK: - KeyBoard Tool Button Action
extension CalorieViewController {
    func checkEmptyTextField(_ textField: UITextField, _ hasText: Bool) {
        if hasText {
            guard let emptyTextField = findEmptyTextField() else { return }
            
            emptyTextField.becomeTextFieldResponder()
            
        } else {
            emptyTextFieldAlert(textField)
        }
    }
}


