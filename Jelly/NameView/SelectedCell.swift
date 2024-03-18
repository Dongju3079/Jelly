//
//  DecideNameCell.swift
//  Jelly
//
//  Created by CatSlave on 3/15/24.
//

import UIKit

class SelectedCell: UICollectionViewCell {
    
    @IBOutlet weak var nameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.contentView.layer.cornerRadius = 20
        
    }
    
}
