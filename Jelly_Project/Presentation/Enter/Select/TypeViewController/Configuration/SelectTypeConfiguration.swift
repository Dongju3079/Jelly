//
//  TypeCollectionDataSource.swift
//  Jelly
//
//  Created by CatSlave on 3/15/24.
//

import UIKit

class TypeCollectionViewConfiguration : NSObject, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UICollectionViewDelegate {
    
    private var selectedCell: ((Selectable) -> Void)?
    private var nextPageName: String = ""
    private var items: [Selectable] = []
    
    func configuration(items: [Selectable],
                       selectedClosure: ((Selectable) -> Void)? = nil,
                       collectionView: UICollectionView) {
        
        self.items = items
        self.selectedCell = selectedClosure
        collectionView.dataSource = self
        collectionView.delegate = self
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SelectCollectionCell.name, for: indexPath) as? SelectCollectionCell else {
            return UICollectionViewCell() }
        
        cell.useCase = items[indexPath.item]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let fullWidth = collectionView.frame.width
        let cellSize = (fullWidth / 2) - 5
        return CGSize(width: cellSize, height: cellSize)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        selectedCell?(items[indexPath.item])
    }
}
