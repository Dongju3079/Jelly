//
//  CalorieViewController.swift
//  Jelly
//
//  Created by CatSlave on 3/15/24.
//

import UIKit
import SnapKit

class CalorieViewController: UIViewController {

    // MARK: - Variables
    var calculateModel : ResultModel? {
        didSet {
            print(#fileID, #function, #line, "-값 제대로 들어옴 칼로리")
            print(calculateModel?.foodType?.title)
        }
    }
    var feedWeightWhenDry: Double = 1_000.0
    
    // MARK: - UI components
    
    @IBOutlet weak var progressBar: UIProgressView!
    @IBOutlet weak var infoLabel: UILabel!
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        progressBar.setupProgressBar(progressBar, 0.8, 1.0)
        setupNaviItem()
        
        guard let currentModel = calculateModel else { return }
        
        if let currentViewType = currentModel.foodType {
            createTypeView(currentViewType)
        }
    }
}

// MARK: - Navigation
extension CalorieViewController {
    fileprivate func setupNaviItem() {
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Next", style: .plain, target: self, action: #selector(nextPage))
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == ResultViewController.name {
            let vc = segue.destination as! ResultViewController
            vc.calculateModel = calculateModel
        }
    }
    
    
    @objc fileprivate func nextPage() {
        performSegue(withIdentifier: ResultViewController.name, sender: nil)
    }
}

// MARK: - 뷰 위치 잡기
extension CalorieViewController {
    
    /// 커스텀 텍스트 뷰 위치잡기
    /// - Parameter mixInputView: FoodType에 맞는 View
    fileprivate func setupUI(_ inputView: UIView) {
        self.view.addSubview(inputView)
        
        inputView.snp.makeConstraints { make in
            make.leading.trailing.equalTo(progressBar)
            make.top.equalTo(infoLabel.snp.bottom).offset(25)
        }
    }
}

// MARK: - 타입에 맞춰서 뷰 생성하기
extension CalorieViewController {
    
    /// 타입에 따라서 뷰 생성
    /// - Parameter elements: 반려동물 식사 타입
    fileprivate func createTypeView(_ elements: FoodType) {
        
        switch elements {
        case .wet:
            makeWetTypeView()
            
        case .dry:
            
            makeDryTypeView()
            
        case .mix:
            
            makeMixTypeView()
            
        }
    }
    
    
    fileprivate func makeWetTypeView() {
        _ = CustomTextFieldView(viewType: .wet,
                                inputTextFieldData: insertCalorie(calorie:foodType:)).then {
            $0.setting(mainTitle: "칼로리", mainSub: "Kcal")
            setupUI($0)
        }
    }
    
    fileprivate func makeDryTypeView() {
        _ = CustomTextFieldView(viewType: .dry,
                                inputTextFieldData: insertCalorie(calorie:foodType:)).then {
            $0.buttonConfiguration(title: "Kg(단위)")
            $0.selectButton.menu = setupMenu($0.selectButton)
            $0.setting(mainTitle: "칼로리", mainSub: "Kcal")
            setupUI($0)
        }
    }
    
    fileprivate func makeMixTypeView() {
        let wetType = CustomTextFieldView(viewType: .wet,
                                          inputTextFieldData: insertCalorie(calorie:foodType:)).then {
            $0.setting(mainTitle: "습식", mainSub: "한 캔 기준", secondTitle: "칼로리", secondSub: "Kcal")
        }
        
        let dryType = CustomTextFieldView(viewType: .dry,
                                          inputTextFieldData: insertCalorie(calorie:foodType:)).then {
            $0.buttonConfiguration(title: "Kg(단위)")
            $0.selectButton.menu = setupMenu($0.selectButton)
            $0.setting(mainTitle: "건식", secondTitle: "칼로리", secondSub: "Kcal")
        }
        
        _ = UIStackView.combineInputView(views: [wetType, dryType]).then({
            setupUI($0)
        })
    }
}




// MARK: - 메뉴 셋팅
extension CalorieViewController {
    
    /// FoodType 중 .dry인 경우 사료 칼로리의 단위를 Kg, g 중 택 1
    /// - Returns: 메뉴
    fileprivate func setupMenu(_ target: UIButton) -> UIMenu {
        
        let menu = UIMenu(children: [
            UIAction(title: "Kg(단위)", handler: { _ in
                target.setTitle("Kg(단위)", for: .normal)
                self.feedWeightWhenDry = 1_000.0
            }),
            UIAction(title: "g(단위)", handler: { _ in
                target.setTitle("g(단위)", for: .normal)
                self.feedWeightWhenDry = 1.0
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
            self.calculateModel?.wetFeedCalorie = calorie
        case .dry:
            self.calculateModel?.dryFeedCalorie = calorie / feedWeightWhenDry
        case .mix:
            break
        }
    }
}
