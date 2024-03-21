//
//  TypeCollectionDataSource.swift
//  Jelly
//
//  Created by CatSlave on 3/15/24.
//

import UIKit

class TypeCollectionDataSource<Item>: NSObject, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UICollectionViewDelegate {
    
    var performSegueClosure: (String, Any?) -> () = { _,_ in  }
    var selectedCell: ((Item) -> Void)?
    
    
    var nextPageName: String = ""
    private var items: [Item] = []
    private var itemsTitle: [String] = []
    
    func configuration(_ items: [Item],
                       _ itemsTitle: [String],
                       _ selectedClosure: ((Item) -> Void)? = nil,
                       _ collectionView: UICollectionView,
                       _ nextPage: String) {
        
        self.items = items
        self.itemsTitle = itemsTitle
        selectedCell = selectedClosure
        self.nextPageName = nextPage
        collectionView.dataSource = self
        collectionView.delegate = self
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SelectedCell.name, for: indexPath) as? SelectedCell else { return UICollectionViewCell() }
        
        
        cell.nameLabel.text = itemsTitle[indexPath.item]
        
    
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let fullWitdh = collectionView.frame.width
        let cellSize = (fullWitdh / 2) - 10
        return CGSize(width: cellSize, height: cellSize)
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedType = items[indexPath.item]
        
        selectedCell?(selectedType)
        performSegueClosure(nextPageName, nil)
    }
}
