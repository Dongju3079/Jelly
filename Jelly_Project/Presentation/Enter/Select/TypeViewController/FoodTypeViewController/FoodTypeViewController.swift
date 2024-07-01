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
        self.navigationItem.leftBarButtonItem = .getImageItem(target: self,
                                                         action: #selector(popViewController))  
    }
    
    fileprivate func setupCollectionView() {
        selectView.collectionView.delegate = self
        selectView.collectionView.dataSource = self
        
    }
    
    // MARK: - 화면 이동
    @objc fileprivate func popViewController() {
        selectView.downGaugeAtPop()
        self.navigationController?.popViewController(animated: true)
    }
}

extension FoodTypeViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return FoodType.allCases.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SelectCollectionCell.name, for: indexPath) as? SelectCollectionCell else {
            return UICollectionViewCell() }
        
        cell.useCase = FoodType.allCases[indexPath.item]
        return cell
    }
}

extension FoodTypeViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let selectType = FoodType.allCases[indexPath.item]
        pushNextVC(selectType)
    }
}

extension FoodTypeViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let fullWidth = collectionView.frame.width
        let cellSize = (fullWidth / 2) - 5
        return CGSize(width: cellSize, height: cellSize)
    }
}

// MARK: - Helper
extension FoodTypeViewController {
    fileprivate func pushNextVC(_ selectType: FoodType) {
        guard let navigation = self.navigationController as? CustomNavigation else { return }
        
        dataManager.currentPetStatus?.foodType = selectType
        navigation.pushToViewController(destinationVCCase: .status)
    }
}
