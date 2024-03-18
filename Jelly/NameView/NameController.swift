//
//  DecideNameController.swift
//  Jelly
//
//  Created by CatSlave on 3/14/24.
//
import Foundation
import UIKit

class NameController: UIViewController {
    
    // MARK: - Variables
    var nameArray: [String] = ["짱아", "나비", "+"]
    var beforeGauge: Float = 0.0
    var nextGauge: Float = 0.2
    
    var snapShot = NSDiffableDataSourceSnapshot<Int, String>()
    var dataSource: UICollectionViewDiffableDataSource<Int, String>? = nil
    
    // MARK: - UI components
    @IBOutlet weak var progressBar: UIProgressView!
    @IBOutlet weak var nameCollectionView: UICollectionView!
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configuraCollectionView()
        progressBar.setupProgressBar(progressBar, 0.0, 0.2)
    }
}

// MARK: - 데이터 전달
extension NameController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == FoodTypeViewController.name {
            let vc = segue.destination as! FoodTypeViewController
            // 전달할 데이터
        }
    }
}

// MARK: - CollectionView SetUP
extension NameController {
    fileprivate func configuraCollectionView() {
        nameCollectionView.delegate = self
        nameCollectionView.showsVerticalScrollIndicator = false
        dataSource = UICollectionViewDiffableDataSource(collectionView: nameCollectionView, cellProvider: { collectionView, indexPath, item in
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SelectedCell.name, for: indexPath) as? SelectedCell else { return nil }
            
            cell.nameLabel.text = item
            return cell
        })
        
        self.setupData(self.nameArray, animation: true)
    }
    
    fileprivate func setupData(_ upData: [String], animation: Bool = true) {
        self.snapShot = NSDiffableDataSourceSnapshot<Int, String>()
        self.snapShot.appendSections([0])
        self.snapShot.appendItems(upData, toSection: 0)
        self.dataSource?.apply(snapShot, animatingDifferences: animation)
    }
}

// MARK: - FlowLatout
extension NameController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let fullWitdh = collectionView.frame.width
        let cellSize = (fullWitdh / 2) - 10
        return CGSize(width: cellSize, height: cellSize)
    }
}

// MARK: - Selectors
extension NameController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print(#fileID, #function, #line, "- ")
        
        if indexPath.item == (self.nameArray.count-1) {
            addNameAlert()
        } else {
            performSegue(withIdentifier: FoodTypeViewController.name, sender: nil)
        }
    }


}

// MARK: - Alert
extension NameController {
    
    func addNameAlert() {
        let alert = UIAlertController(title: "이름 추가하기", message: "내새끼의 이름을 입력해주세요.", preferredStyle: .alert)
        alert.addTextField()
        alert.textFields?.first?.placeholder = "이름를 입력하세요."
        alert.addAction(UIAlertAction(title: NSLocalizedString("추가", comment: "Default action"), style: .default, handler: { [weak self] _ in
            print(#fileID, #function, #line, "-이름생성 ")
            guard let userInput = alert.textFields?.first?.text,
                  let self = self
            else { return }
            
            if self.nameArray.contains(userInput) {
                helpAlert()
                
            } else {
                self.newName(userInput)
            }

        }))
        alert.addAction(UIAlertAction(title: "취소", style: .cancel))
        self.present(alert, animated: true, completion: nil)
    }
    
    
    func helpAlert() {
        let alert = UIAlertController(title: nil, message: "이미 등록된 이름입니다.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString("확인", comment: "Default action"), style: .default, handler: {  _ in
            print(#fileID, #function, #line, "-이름생성 ")
        }))
        self.present(alert, animated: true, completion: nil)
    }
}

// MARK: - 이름 추가하기
extension NameController {
    fileprivate func newName(_ newName: String) {
        
    
        if let firstItem = snapShot.itemIdentifiers(inSection: 0).first {
            self.nameArray.insert(newName, at: 0)
            snapShot.insertItems([newName], beforeItem: firstItem)
        } else {
            snapShot.appendItems([newName], toSection: 0)
        }
        
        self.dataSource?.apply(self.snapShot, animatingDifferences: true)
    }
}
