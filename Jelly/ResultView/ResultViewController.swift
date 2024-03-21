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
    var calculateModel : ResultModel?
    
    // 혼합인 경우 칼로리 계산 후 습식에 MaxCount를 넣어주는 로직 필요
    var wetFeedMaxCount: Int {
        guard let calculateModel = calculateModel else { return 0 }
        return calculateModel.maxWetFeedCount()
    }
    
    var wetFeedCount: Int = 1
    
    @IBOutlet weak var petInfoView: UIStackView!
    
    private let resultContentView = UIView().then {
        $0.layer.masksToBounds = true
        $0.layer.cornerRadius = 8
        $0.backgroundColor = .systemGray
    }
    
    private let resultScrollView = UIScrollView().then {
        $0.isUserInteractionEnabled = true
        $0.showsVerticalScrollIndicator = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let feedType = calculateModel?.foodType {
            createTypeView(feedType)
        }
    }
}

// MARK: - 뷰 위치 잡기
extension ResultViewController {
    fileprivate func setupUI(_ content: UIView) {
        self.view.addSubview(resultScrollView)
        self.resultContentView.addSubview(content)
        self.resultScrollView.addSubview(resultContentView)
    
        content.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        resultContentView.snp.makeConstraints { make in
            make.edges.equalTo(resultScrollView.contentLayoutGuide.snp.edges)
            make.width.equalTo(resultScrollView.frameLayoutGuide.snp.width)
        }
        
        resultScrollView.snp.makeConstraints { make in
            make.top.equalTo(petInfoView.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview().inset(20)
            make.bottom.equalToSuperview()
        }
    }
}

// MARK: - 타입에 맞춰서 뷰 생성하기
extension ResultViewController {
    
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
    
    fileprivate func makeMixTypeView() {
        let dryView = CustomTextFieldView(userTextField: false).then {
            $0.setting(mainTitle: "1일 권장 급여량")
            $0.setupLeftLabel("건식")
            
            // 적정 갯수 계산 후
            $0.inputTextFieldValue = self.dryFeedAmountOfWetFeedCount(count: 1)
        }
        
        let wetView = CustomTextFieldView(userTextField: false).then {
            $0.setting(mainTitle: "1일 권장 급여량")
            $0.selectButton.menu = setupMenu(currentView: $0, linkView: dryView)
            $0.buttonConfiguration(scale: .large)
            $0.setupLeftLabel("습식")
            
            // 적정 갯수 계산 후
            $0.inputTextFieldValue = "1 캔"
        }
        
        let adequateCalorie = calculateModel?.adequateCalorie().convertString
        
        _ = UIStackView.combineOutputView(topView: wetView, bottomView: dryView, adequateCalorie: adequateCalorie).then({
            setupUI($0)
        })
    }
    
    fileprivate func makeDryTypeView() {
        let dryView = CustomTextFieldView(userTextField: false).then {
            $0.setting(mainTitle: "1일 권장 급여량")
            
            if let RER = calculateAmount(.dry) {
                // 적정 갯수 계산 후
                $0.inputTextFieldValue = RER + "g"
            }
        }
        
        let adequateCalorie = calculateModel?.adequateCalorie().convertString
        
        _ = UIStackView.combineOutputView(topView: dryView, bottomView: nil, adequateCalorie: adequateCalorie).then({
            setupUI($0)
        })
    }
    
    fileprivate func makeWetTypeView() {
        let wetView = CustomTextFieldView(userTextField: false).then {
            $0.setting(mainTitle: "1일 권장 급여량")
            
            if let count = calculateAmount(.wet) {
                $0.inputTextFieldValue = count + "캔"
            }
        }
        
        let adequateCalorie = calculateModel?.adequateCalorie().convertString
        
        _ = UIStackView.combineOutputView(topView: wetView, bottomView: nil, adequateCalorie: adequateCalorie).then({
            setupUI($0)
        })
    }
}

// MARK: - 메뉴 셋팅
extension ResultViewController {
    fileprivate func setupMenu(currentView: CustomTextFieldView, linkView: CustomTextFieldView) -> UIMenu? { // wetFeedMaxCount가 계산된 이후에 사용
        
        if wetFeedMaxCount >= 1 {
            let currentMenuCount = 0...wetFeedMaxCount
            
            let actions = currentMenuCount.map { count in
                UIAction(title: "\(count)캔 급여") { [weak self] _ in
                    self?.wetFeedCount = count
                    currentView.inputTextFieldValue = "\(count) 캔"
                    
                    linkView.inputTextFieldValue = self?.dryFeedAmountOfWetFeedCount(count: count)
                }
            }
            
            let menu = UIMenu(title: "습식 갯수", children: actions)
            
            return menu
        } else {
            return nil
        }
    }
}

// MARK: - 칼로리 계산 로직
extension ResultViewController {
    fileprivate func calculateAmount(_ element: FoodType) -> String? {
        
        switch element {
        case .wet:
            return amountOfFeed(.wet)
            
        case .dry:
            return amountOfFeed(.dry)
            
        case .mix:
            return nil
        }
        
    }
    
    fileprivate func amountOfFeed(_ element: FoodType) -> String? {
        guard let calculateModel = calculateModel,
              let calorie = element == .dry ? calculateModel.dryFeedCalorie : calculateModel.wetFeedCalorie else { return nil }
        
        let adequateCalorie = calculateModel.adequateCalorie()
        
        return (adequateCalorie / calorie).convertString
    }
    
    fileprivate func dryFeedAmountOfWetFeedCount(count: Int) -> String? {
        guard let calculateModel = calculateModel,
              let dryFeedCalorie = calculateModel.dryFeedCalorie,
              let wetFeedCalorie = calculateModel.wetFeedCalorie else { return nil }
        
        let adequateCalorie = calculateModel.adequateCalorie()
        let allottedWetFeed = wetFeedCalorie * Double(count)
        let allottedDryFeed = adequateCalorie - allottedWetFeed
        
        if allottedDryFeed > dryFeedCalorie {
            return (allottedDryFeed / dryFeedCalorie).convertString + "g"
        } else {
            return "0" + "g"
        }
    }
    
    
    
    
}
