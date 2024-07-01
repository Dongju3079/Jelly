//
//  SelectCollectionCell.swift
//  Jelly
//
//  Created by CatSlave on 5/2/24.
//

import Foundation
import UIKit

protocol DeleteDelegate: NSObject {
    func deleteButtonClosure(_ deleteItem: Selectable) -> Void
}

class SelectCollectionCell: UICollectionViewCell {
    
    weak var delegate: DeleteDelegate?

    var useCase: Selectable? {
        didSet {
            guard let useCase = useCase else { return }
            nameLabel.text = useCase.name
        }
    }
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var typeImage: UIImageView!
    @IBOutlet weak var deleteButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupLayer()
    }
    
    override func draw(_ rect: CGRect) {
        if !(useCase is PetInfo) {
            setupImage()
        } else {
            typeImage.isHidden = true
        }
    }
    
    func showDeleteButton(_ isDeleteMode: Bool) {

        deleteButton.isHidden = !isDeleteMode
    }
    
    fileprivate func setupLayer() {
        self.clipsToBounds = true
        self.contentView.layer.cornerRadius = 20
        self.layer.masksToBounds = false
        self.makeShadow()
    }
    
    fileprivate func setupImage() {
        
        let imageHeight = self.typeImage.frame.height
        let imageWidth = self.typeImage.frame.width
                
        guard let useCase = useCase else { return }
        let image = UIImage(named: "\(useCase.self)")
        
        let changeSizeImage = image?.scalePreservingAspectRatio(targetSize: CGSize(width: imageWidth, height: imageHeight))

        typeImage.image = changeSizeImage
    }
    
    @IBAction func deleteButtonTapped(_ sender: UIButton) {
        guard let useCase = useCase else { return }

        delegate?.deleteButtonClosure(useCase)
    }
}
