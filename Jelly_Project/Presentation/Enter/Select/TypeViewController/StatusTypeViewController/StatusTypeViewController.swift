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
    
    private var currentTypes: [StatusType] = []

    private let dataManager = DataManager.shared
    private let collectionViewSetup = TypeCollectionViewConfiguration()

    // MARK: - UI components
    private lazy var selectView = SelectCollectionView(enterType: .status).then {
        $0.setTipButton(delegate: self)
        $0.setTipButtonTag(num: Self.currentViewPriority)
    }
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    deinit {
        print("👾 테스트 : \(self)뷰가 해제되고 있습니다. 👾")
    }
    
    // MARK: - UI Setup
    fileprivate func setupUI() {
        self.title = "상태 선택"
        self.view = selectView
        setupNaviItem()
        setupCollectionView()
    }
    
    fileprivate func setupNaviItem() {
        self.navigationItem.leftBarButtonItem = .getImageItem(target: self,
                                                         action: #selector(popViewController))
    }
    
    fileprivate func setupCollectionView() {
        
        self.currentTypes = StatusType.getAllTypesOfPriority(priority: StatusTypeViewController.currentViewPriority)
        
        selectView.collectionView.delegate = self
        selectView.collectionView.dataSource = self
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
        
        guard let navigation = self.navigationController as? CustomNavigation else { return }
        
        StatusTypeViewController.upReuseCount()
        navigation.pushToViewController(destinationVCCase: .status)
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

extension StatusTypeViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return currentTypes.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SelectCollectionCell.name, for: indexPath) as? SelectCollectionCell else {
            return UICollectionViewCell() }
        
        cell.useCase = currentTypes[indexPath.item]
        return cell
    }
}

extension StatusTypeViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let selectType = currentTypes[indexPath.item]
        selectedCell(selectType)
    }
}

extension StatusTypeViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let fullWidth = collectionView.frame.width
        let cellSize = (fullWidth / 2) - 5
        return CGSize(width: cellSize, height: cellSize)
    }
}

extension StatusTypeViewController: TipSelectDelegate {
    func tapTipButton(tag: Int) {
        switch tag {
        case 0:
            CustomPopup.shared.showCustomPopup(type: .ageTip)
        default:
            CustomPopup.shared.showCustomPopup(type: .obesityTip)
        }
    }
    
    
}
