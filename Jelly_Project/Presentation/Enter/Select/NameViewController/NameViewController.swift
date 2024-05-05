//
//  DecideNameController.swift
//  Jelly
//
//  Created by CatSlave on 3/14/24.
//
import Foundation
import UIKit
import Then

class NameViewController: UIViewController {
    
    // MARK: - Variables

    private let dataManager = DataManager.shared
    
    private var menuMode: Bool = false
    private var deleteMode: Bool = false
    
    private var snapShot = NSDiffableDataSourceSnapshot<Int, ObjectInformation>()
    private var dataSource: UICollectionViewDiffableDataSource<Int, ObjectInformation>? = nil
    
    private lazy var selectView = SelectCollectionView(enterType: .name,
                                                       tapAddButton: self.showAddAlert,
                                                       tapDeleteButton: onEditMode,
                                                       checkEditMode: checkEditMode)//.then {
//        $0.setFloaty()
//    }
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        checkEmptyView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    // MARK: - UI Setup
    fileprivate func setupUI() {
        self.title = "이름 선택"
        self.view = selectView

        setupNaviItem()
        configurationCollectionView(nameCollectionView: selectView.collectionView)
    }
    
    fileprivate func setupNaviItem() {
        self.navigationItem.leftBarButtonItem = .getItem(target: self, action: #selector(popViewController))
    }
}

// MARK: - Floating Button

extension NameViewController {
    
    fileprivate func showAddAlert() {
        AlertManager.shared.addNameAlert(target: self, completion: self.addObject(_:))
        checkEditMode()
    }
    
    fileprivate func onEditMode() {
        deleteMode = true
        
        self.snapShot.reloadSections([0])
        self.dataSource?.apply(snapShot, animatingDifferences: true)
    }

    fileprivate func changeEditMode() {
        deleteMode.toggle()
        
        self.snapShot.reloadSections([0])
        self.dataSource?.apply(snapShot, animatingDifferences: true)
    }
    
    fileprivate func checkEditMode() {
        if deleteMode {
            changeEditMode()
        }
    }
}

// MARK: - CollectionView Setup
extension NameViewController {
    
    fileprivate func configurationCollectionView(nameCollectionView: UICollectionView) {

        nameCollectionView.delegate = self
        
        dataSource = UICollectionViewDiffableDataSource(collectionView: nameCollectionView, cellProvider: { [weak self] collectionView, indexPath, item in
            
            guard let self = self else { return UICollectionViewCell() }
            
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SelectCollectionCell.name, for: indexPath) as? SelectCollectionCell else { return UICollectionViewCell() }
            
            cell.deleteButtonClosure = deleteObject(_:)
            cell.showDeleteButton(self.deleteMode)
            cell.useCase = item
            
            return cell
        })
        
        setupData(dataManager.objects, animation: false)
    }
    
    fileprivate func setupData(_ upData: [ObjectInformation], animation: Bool = true) {
        self.snapShot = NSDiffableDataSourceSnapshot<Int, ObjectInformation>()
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
    
    fileprivate func addObject(_ sectionTitle: String) {
        let newItem = dataManager.makeNewObjectToDB(sectionTitle)
        checkEmptyView()
        getToAdd(newItem)
        self.dataSource?.apply(self.snapShot, animatingDifferences: true)
    }
    
    fileprivate func getToAdd(_ newItem: ObjectInformation) {
        if let firstItem = snapShot.itemIdentifiers(inSection: 0).first {
            snapShot.insertItems([newItem], beforeItem: firstItem)
        } else {
            snapShot.appendItems([newItem], toSection: 0)
        }
    }
    
    fileprivate func deleteObject(_ deleteItem: Selectable) {

        guard let deleteItem = deleteItem as? ObjectInformation else { return }
        dataManager.deleteObjectToDB(deleteItem)
        snapShot.deleteItems([deleteItem])
        checkEmptyView()
        self.dataSource?.apply(self.snapShot, animatingDifferences: true)
    }
}

extension NameViewController {
    
    fileprivate func checkEmptyView() {
        selectView.emptyLabel.isHidden = !dataManager.checkObjectDataEmpty()
    }
    
}
