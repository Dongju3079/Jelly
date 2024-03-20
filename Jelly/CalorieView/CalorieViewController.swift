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
    var currentModel : ResultModel? = ResultModel(foodType: .mix)
    
    // MARK: - UI components
    
    @IBOutlet weak var progressBar: UIProgressView!
    @IBOutlet weak var infoLabel: UILabel!
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        progressBar.setupProgressBar(progressBar, 0.8, 1.0)
        setupNaviItem()
        
        guard let currentModel = currentModel else { return }
        
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
    
    
    @objc fileprivate func nextPage() {
        performSegue(withIdentifier: ResultViewController.name, sender: nil)
    }
}

// MARK: - UI Setup
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
    
    
    /// 타입에 따라서 뷰 생성
    /// - Parameter elements: 반려동물 식사 타입
    fileprivate func createTypeView(_ elements: FoodType) {
        
        if elements == .mix {
            
            let doubleView = UIView.makeMixView(
                (CustomType.doubleInput(foodType: .wet), nil, firstInputData(_:)),
                (CustomType.doubleInput(foodType: .dry), true, secondInputData(_:))
            )
            
            setupUI(doubleView)
        } else {
            let onButton = elements == .dry ? true : false
            let singleView = UIView.makeSingleView(
                (CustomType.singleInput(foodType: elements), onButton, firstInputData(_:)))
            setupUI(singleView)
        }
    }
    
    fileprivate func firstInputData(_ input: String) -> Void {
            print("첫번째 칸입니다. : \(input)")
    }
    
    fileprivate func secondInputData(_ input: String) -> Void {
            print("두번째 칸입니다. : \(input)")
    }
    
}



// MARK: - 메뉴액션 만들기
extension CalorieViewController {
    
    /// FoodType 중 .dry인 경우 사료 칼로리의 단위를 Kg, g 중 택 1
    /// - Returns: 메뉴
    fileprivate func setupMenu() -> UIMenu {
        
        let menu = UIMenu(children: [
            UIAction(title: "Kg(단위)", handler: { _ in
                print("")
            }),
            UIAction(title: "g(단위)", handler: { _ in
                print("2번 선택")
            })
        ])
        
        return menu
    }
}
