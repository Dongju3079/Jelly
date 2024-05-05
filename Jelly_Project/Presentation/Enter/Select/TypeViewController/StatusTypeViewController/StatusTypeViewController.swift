//
//  DecideStatusViewController.swift
//  Jelly
//
//  Created by CatSlave on 3/15/24.
//

import UIKit
import Then

class StatusTypeViewController: UIViewController {
    
    // MARK: - Variables
    static private var currentViewPriority: Int = 0

    private let dataManager = DataManager.shared
    private let collectionViewSetup = TypeCollectionViewConfiguration()

    // MARK: - UI components
    private lazy var selectView = SelectCollectionView(enterType: .status, tapTipButton: tipButtonTapped(_:)).then {
        $0.setTipButtonTag(num: Self.currentViewPriority)
    }
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    // MARK: - UI Setup
    fileprivate func setupUI() {
        self.title = "상태 선택"
        self.view = selectView
        setupNaviItem()
        setupCollectionView()
    }
    
    fileprivate func setupNaviItem() {
        self.navigationItem.leftBarButtonItem = .getItem(mode: .left, target: self, action: #selector(popViewController))
    }
    
    fileprivate func setupCollectionView() {
        
        let statusTypes = StatusType.getAllTypesOfPriority(priority: StatusTypeViewController.currentViewPriority)
        
        collectionViewSetup.configuration(items: statusTypes,
                                          selectedClosure: selectedCell(_:),
                                          collectionView: selectView.collectionView)
    }

    
    // MARK: - Selectors
   fileprivate func tipButtonTapped(_ sender: UIButton) {
        switch sender.tag {
        case 0:
            CustomPopup.shared.showCustomPopup(type: .ageTip)
        default:
            CustomPopup.shared.showCustomPopup(type: .obesityTip)
        }
    }
}

// MARK: - 화면이동

extension StatusTypeViewController {
    
    fileprivate func selectedCell(_ selectType: Selectable) {
        
        guard let statusType = selectType as? StatusType else { return }
        
        switch statusType {
        case .adult, .ideal:
            pushReselectVC()
        default:
            pushNextVC(statusType)
        }
    }
    
    fileprivate func pushNextVC(_ selectedType: StatusType) {
        guard let navigation = self.navigationController as? CustomNavigation else { return }
        dataManager.currentDetailInfo?.status = selectedType
        navigation.pushToViewController(destinationVCCase: .weight)
    }
    
    fileprivate func pushReselectVC() {
        StatusTypeViewController.upReuseCount()
        self.navigationController?.pushViewController(StatusTypeViewController(), animated: true)
    }
    
    @objc fileprivate func popViewController() {
        setProgressBar()
        StatusTypeViewController.downReuseCount()
        self.navigationController?.popViewController(animated: true)
    }
}

// MARK: - 우선순위 설정

extension StatusTypeViewController {
    
    static func upReuseCount() {
        if StatusTypeViewController.currentViewPriority < 2 {
            StatusTypeViewController.currentViewPriority += 1
        }
    }
    
    static func downReuseCount() {
        if StatusTypeViewController.currentViewPriority != 0 {
            StatusTypeViewController.currentViewPriority -= 1
        }
    }
    
    static func resetReuseCount() {
        StatusTypeViewController.currentViewPriority = 0
    }
}

// MARK: - Helper

extension StatusTypeViewController {
    fileprivate func setProgressBar() {
        if Self.currentViewPriority == 0 {
            selectView.downGaugeAtPop()
        }
    }
}
