//
//  TypeCollectionDataSource.swift
//  Jelly
//
//  Created by CatSlave on 3/15/24.
//

import UIKit

class TypeCollectionDataSource<Item>: NSObject, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UICollectionViewDelegate {
    
    var performSegueClosure: (String, Any?) -> () = { _,_ in  }
    var nextPageName: String = ""
    private var items: [Item] = []
    
    func configuration(_ items: [Item], _ collectionView: UICollectionView, _ nextPage: String) {
        self.items = items
        self.nextPageName = nextPage
        collectionView.dataSource = self
        collectionView.delegate = self
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SelectedCell.name, for: indexPath) as? SelectedCell else { return UICollectionViewCell() }
        
        if let type = items[indexPath.item] as? String {
            cell.nameLabel.text = type
        }
    
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let fullWitdh = collectionView.frame.width
        let cellSize = (fullWitdh / 2) - 10
        return CGSize(width: cellSize, height: cellSize)
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        performSegueClosure(nextPageName, nil)
    }
}
