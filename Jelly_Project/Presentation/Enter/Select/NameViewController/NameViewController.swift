//
//  DecideNameController.swift
//  Jelly
//
//  Created by CatSlave on 3/14/24.
//
import Foundation
import UIKit
import RxSwift
import RxCocoa
import Then

class NameViewController: UIViewController {
    
    
    
    // MARK: - Variables

    private let dataManager = DataManager.shared
    
    private var menuMode: Bool = false
    private var deleteMode: Bool = false
    private var snapShot = NSDiffableDataSourceSnapshot<Int, PetInfo>()
    private var dataSource: UICollectionViewDiffableDataSource<Int, PetInfo>? = nil
    
    private lazy var selectView = SelectCollectionView(enterType: .name).then {
        $0.setFloatyButton(delegate: self)
    }
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        checkEmptyView()
    }
    
    // MARK: - UI Setup
    
    fileprivate func setupUI() {
        self.title = "이름 선택"
        self.view = selectView

        setupNaviItem()
        configurationCollectionView()
    }
    
    fileprivate func setupNaviItem() {
        self.navigationItem.leftBarButtonItem = .getImageItem(target: self,
                                                         action: #selector(popViewController))
    }
}

// MARK: - CollectionView Setup
extension NameViewController {
    
    fileprivate func configurationCollectionView() {

        selectView.collectionView.delegate = self
        
        dataSource = UICollectionViewDiffableDataSource(collectionView: selectView.collectionView, cellProvider: { [weak self] collectionView, indexPath, item in
            
            guard let self = self else { return UICollectionViewCell() }
            
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SelectCollectionCell.name, for: indexPath) as? SelectCollectionCell else { return UICollectionViewCell() }
            
            cell.delegate = self
            cell.showDeleteButton(deleteMode)
            cell.useCase = item
            
            return cell
        })
        
        setupData(dataManager.petInfos, animation: false)
    }
    
    fileprivate func setupData(_ upData: [PetInfo], animation: Bool = true) {
        self.snapShot = NSDiffableDataSourceSnapshot<Int, PetInfo>()
        self.snapShot.appendSections([0])
        self.snapShot.appendItems(upData, toSection: 0)
        self.dataSource?.apply(snapShot, animatingDifferences: animation)
    }
}

// MARK: - FlowLayout

extension NameViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let fullWidth = collectionView.frame.width
        let cellSize = (fullWidth / 2) - 5
        return CGSize(width: cellSize, height: cellSize)
    }
}

// MARK: - Helper
extension NameViewController {
    
    fileprivate func checkEmptyView() {
        selectView.emptyLabel.isHidden = !dataManager.checkPetInfoDataEmpty()
    }
    
}

// MARK: - 화면이동

extension NameViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        dataManager.makeDetailToObject(index: indexPath)
        
        if let navigation = self.navigationController as? CustomNavigation {
            navigation.pushToViewController(destinationVCCase: .food)
        }
    }
    
    @objc fileprivate func popViewController() {	
        selectView.downGaugeAtPop()
        self.navigationController?.popViewController(animated: true)
    }
}

// MARK: - 이름 추가하기

extension NameViewController {
    
    fileprivate func addPetInfo(_ sectionTitle: String) {
        let newItem = dataManager.makePetInfo(sectionTitle)
        checkEmptyView()
        getToAdd(newItem)
        self.dataSource?.apply(self.snapShot, animatingDifferences: true)
    }
    
    fileprivate func getToAdd(_ newItem: PetInfo) {
        if let firstItem = snapShot.itemIdentifiers(inSection: 0).first {
            snapShot.insertItems([newItem], beforeItem: firstItem)
        } else {
            snapShot.appendItems([newItem], toSection: 0)
        }
    }
}

// MARK: - 플로팅 버튼 액션
extension NameViewController: FloatySelectDelegate {
    func tapDeleteButton() {
        deleteMode = true
        self.snapShot.reloadSections([0])
        self.dataSource?.apply(snapShot, animatingDifferences: true)
    }
    
    func tapAddButton() {
        print("👾 테스트 : 탭 메서드 실행 👾")
        AlertManager.shared.addNameAlert(target: self) { [weak self] userInput in
            guard let self = self else { return }
            self.addPetInfo(userInput)
        }
    }
    
    func checkDeleteMode() {
        if deleteMode {
            changeEditMode()
        }
    }
    
    fileprivate func changeEditMode() {
        deleteMode.toggle()
        
        self.snapShot.reloadSections([0])
        self.dataSource?.apply(snapShot, animatingDifferences: true)
    }
}
extension NameViewController: DeleteDelegate {
    
    func deleteButtonClosure(_ deleteItem: Selectable) {

        guard let deleteItem = deleteItem as? PetInfo else { return }
        dataManager.deleteObjectToDB(deleteItem)
        snapShot.deleteItems([deleteItem])
        checkEmptyView()
        self.dataSource?.apply(self.snapShot, animatingDifferences: true)
    }
}

extension NameViewController: UIScrollViewDelegate {

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        print("테스트 Y : \(scrollView.contentOffset.y)")
        self.selectView.showMaskingView(offSet: scrollView.contentOffset.y)
    }
}
