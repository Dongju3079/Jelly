//
//  DecideNameViewController.swift
//  Jelly
//
//  Created by CatSlave on 3/15/24.
//

import UIKit

class FoodTypeViewController: UIViewController {

    // MARK: - Variables

    private let dataManager = DataManager.shared
    private let collectionViewSetup = TypeCollectionViewConfiguration()
    
    // MARK: - UI components
    private lazy var selectView = SelectCollectionView(enterType: .food)
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    // MARK: - UI Setup
    
    fileprivate func setupUI() {
        self.title = "급여타입 선택"
        self.view = selectView
        setupNaviItem()
        setupCollectionView()
    }

    fileprivate func setupNaviItem() {
        self.navigationItem.leftBarButtonItem = .getItem(target: self, action: #selector(popViewController))
    }
    
    fileprivate func setupCollectionView() {
        
        collectionViewSetup.configuration(items: FoodType.allCases,
                                          selectedClosure: selectedCell(_:),
                                          collectionView: selectView.collectionView)
    }
    
    // MARK: - 화면 이동
    @objc fileprivate func popViewController() {
        selectView.downGaugeAtPop()
        self.navigationController?.popViewController(animated: true)
    }
    
    // MARK: - 셀 선택 액션
    
    fileprivate func selectedCell(_ selectType: Selectable) {
        guard let navigation = self.navigationController as? CustomNavigation,
              let foodType = selectType as? FoodType else { return }
        
        dataManager.currentDetailInfo?.foodType = foodType
        navigation.pushToViewController(destinationVCCase: .status)
    }
}


