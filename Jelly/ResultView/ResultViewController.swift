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
    var currentModel : ResultModel? = ResultModel.init(foodType: .mix)
    
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
        
        if let viewType = currentModel?.foodType {
            createTypeView(viewType)
        }
    }
    
    /// 타입에 따라서 뷰 생성
    /// - Parameter elements: 반려동물 식사 타입
    fileprivate func createTypeView(_ elements: FoodType) {
        if elements == .mix {
            let mixView = UIView.makeMixView(
                (CustomType.outputOfType(outputType: .onButton), true, firstInputData(_:)),
                (CustomType.outputOfType(outputType: .nonButton(showLabel: true)), nil, nil), 20)

            setupUI(UIStackView.makeResultView(mixView))
        } else {
            let singleView = UIView.makeSingleView((CustomType.outputOfType(outputType: .nonButton(showLabel: false)), nil, nil))
            
            setupUI(UIStackView.makeResultView(singleView))
        }
    }
    
    fileprivate func firstInputData(_ input: String) -> Void {
            print("첫번째 칸입니다. : \(input)")
    }
    
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
    
    fileprivate func setupAction() -> UIMenu {
        let menu = UIMenu(children: [
            UIAction(title: "1번", handler: { _ in
                print("1번 선택")
            }),
            UIAction(title: "2번", handler: { _ in
                print("2번 선택")
            }),
            UIAction(title: "3번", handler: { _ in
                print("3번 선택")
            }),
            UIAction(title: "4번", handler: { _ in
                print("4번 선택")
            })
        ])
        
        return menu
    }

}
