//
//  FloatyButton.swift
//  Jelly_Project
//
//  Created by CatSlave on 5/7/24.
//

import Floaty

class FloatyInit {
    
    weak var delegate: FloatySelectDelegate?
    
    enum UseCase {
        case plus
        case edit
    }
    
    deinit {
        print("👾 테스트 : floaty 해제됨 👾")
    }
    
    func getFloatyButton(delegate: FloatySelectDelegate?,
                                image: ImageSet.Name = .plus,
                                size: CGFloat = 70,
                                color: UIColorSet.Color.Button = .green,
                                items: [UseCase] = [.edit, .plus]) -> Floaty {
        self.delegate = delegate
        let floaty = Floaty()
        floaty.hasShadow = false
        floaty.size = size
        floaty.paddingY = 40
        floaty.paddingX = 20
        floaty.buttonColor = UIColorSet.button(color)
        
        floaty.buttonImage = ImageSet
            .getImage(name: image)?
            .withRenderingMode(.alwaysTemplate)
        
        floaty.plusColor = .white
        
        items.forEach { self.getItem(floaty: floaty, delegate: self.delegate, useCase: $0) }

        return floaty
    }
    
    fileprivate func getItem(floaty: Floaty, delegate: FloatySelectDelegate?, useCase: UseCase) {
        switch useCase {
        case .plus:
            floaty.addItem("추가", icon: ImageSet.getImage(name: .plus)) { [weak self] _ in
                
                guard let self = self else { return }
                
                self.delegate?.tapAddButton()
            }
        case .edit:
            floaty.addItem("편집", icon: ImageSet.getImage(name: .minus)) { [weak self] _ in
                guard let self = self else { return }
                self.delegate?.tapDeleteButton()
            }
        }
    }
    
}
