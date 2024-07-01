//
//  ResultViewController.swift
//  Jelly
//
//  Created by CatSlave on 3/18/24.
//

import UIKit
import SnapKit
import Then

class ResultViewController: UIViewController {
    
    // MARK: - Variables
    private let dataManager = DataManager.shared
    private var currentTextView: [String: CustomTextFieldView] = [:]
    
    // MARK: - UI components
    
    @IBOutlet weak var containerInfoView: UIView!
    @IBOutlet weak var containerCalorieView: UIView!

    @IBOutlet weak var petInfoView: UIStackView!
    @IBOutlet weak var foodTypeLabel: UILabel!
    @IBOutlet weak var statusTypeLabel: UILabel!
    @IBOutlet weak var weightLabel: UILabel!
    @IBOutlet weak var calorieView: UIStackView!

    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    // MARK: - UI Setup
    fileprivate func setupUI() {
        setupNaviItem()
        setupLayer()
        createTypeView()
    }
    
    /// 타입에 따라서 뷰 생성
    /// - Parameter elements: 반려동물 식사 타입
    fileprivate func createTypeView() {
        
        guard let detailInfo = dataManager.currentPetStatus,
              let foodType = detailInfo.foodType else { return }

        setupInfoLabel(detailInfo)
        
        switch foodType {
        case .wet:
            makeWetTypeView()
            
        case .dry:
            makeDryTypeView()
            
        case .mix:
            makeMixTypeView()
        }
    }
    
    fileprivate func setupInfoLabel(_ detailInfo: PetStatus) {
        foodTypeLabel.text = detailInfo.foodType?.name ?? "타입 없음"
        statusTypeLabel.text = detailInfo.status?.name ?? "타입 없음"
        weightLabel.text = "\(detailInfo.weight) Kg"
    }

    fileprivate func setupNaviItem() {
        self.title = "결과"
        self.navigationItem.hidesBackButton = true
        self.navigationItem.rightBarButtonItem = UIBarButtonItem.getTitleItem(target: self, action: #selector(completeAction))
    }
    
    fileprivate func setupLayer() {
        self.containerInfoView.makeShadow()
        self.containerCalorieView.makeShadow()
        self.petInfoView.layer.cornerRadius = 8
        self.calorieView.layer.cornerRadius = 8
    }

    // MARK: - Selectors
    
    @objc fileprivate func completeAction() {
        self.navigationController?.popToRootViewController(animated: true)
    }
}

// MARK: - 타입에 맞춰서 뷰 생성하기
extension ResultViewController {
    
    fileprivate func makeMixTypeView() {
        
        let dryView = CustomTextFieldView(usePlace: .output).then {
            $0.setupLeftLabel("건식", true)
            $0.addEmptyView()
            $0.setupTextFieldText(text: dataManager.calculateAmount())
            self.currentTextView.updateValue($0, forKey: "dryView")
        }
        
        let wetView = CustomTextFieldView(usePlace: .output).then {
            $0.setupTopLabel(mainTitle: "1일 권장 급여량")
            self.currentTextView.updateValue($0, forKey: "wetView")
            $0.unitButton.menu = UIMenu.setupCountMenu(action: makeMenuAction(count:),
                                                  maxCount: dataManager.wetFeedMaxCount())
            $0.buttonConfiguration(type: .numberButton, scale: .large)
            $0.setupLeftLabel("습식")
            $0.setupTextFieldText(text: "1 캔")
        }
                
        _ = CustomStackView(type: .output,
                            views: [wetView, dryView],
                            outputResult: dataManager.adequateCalorie()).then({
            calorieView.addArrangedSubview($0)
        })
    }
    
    fileprivate func makeDryTypeView() {
        let dryView = CustomTextFieldView(usePlace: .output).then {
            $0.setupTopLabel(mainTitle: "1일 권장 급여량")
            $0.addEmptyView()
            $0.setupTextFieldText(text: dataManager.calculateAmount())
        }
                
        _ = CustomStackView(type: .output,
                            views: [dryView],
                            outputResult: dataManager.adequateCalorie()).then({
            calorieView.addArrangedSubview($0)
        })
    }
    
    fileprivate func makeWetTypeView() {
        let wetView = CustomTextFieldView(usePlace: .output).then {
            $0.setupTopLabel(mainTitle: "1일 권장 급여량")
            $0.addEmptyView()
            $0.setupTextFieldText(text: dataManager.calculateAmount())
        }
           
        _ = CustomStackView(type: .output,
                            views: [wetView],
                            outputResult: dataManager.adequateCalorie()).then({
            calorieView.addArrangedSubview($0)
        })
    }
}

// MARK: -  메뉴 셋팅
extension ResultViewController {
    fileprivate func makeMenuAction(count: Int) -> UIAction {
        return UIAction(title: "\(count)캔 급여") { [weak self] _ in
            if let self = self,
               let dryView = self.currentTextView["dryView"],
               let wetView = self.currentTextView["wetView"] {
                
                wetView.setupTextFieldText(text: "\(count) 캔")
                dryView.setupTextFieldText(text: self.dataManager.dryFeedAmountOfWetFeedCount(count))
            }
        }
    }
}
