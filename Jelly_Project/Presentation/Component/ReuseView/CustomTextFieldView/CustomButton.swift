//
//  CustomButton.swift
//  Jelly
//
//  Created by CatSlave on 4/10/24.
//

import UIKit
import Then

class CustomButton: UIButton {
    
    enum UseType {
        case empty
        case unitButton
        case numberButton
    }
    
    var useType: UseType?
    
    init(type: UseType) {
        super.init(frame: .zero)
        self.useType = type
        setDefault()
        setFont()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        print("👾 테스트 : 버튼이 해제됩니닫. 👾")
    }
    
    fileprivate func setDefault() {
        self.isEnabled = false
        self.showsMenuAsPrimaryAction = true

        let customConfiguration = UIButton.Configuration.plain()
        self.configuration = customConfiguration
    }
    
    fileprivate func setFont() {
        let transformer = UIConfigurationTextAttributesTransformer { incoming in
            var outgoing = incoming
            outgoing.foregroundColor = UIColorSet.button(.gray)
            outgoing.font = UIFont(customStyle: .bold, size: 15)
            return outgoing
        }
        
        self.configuration?.titleTextAttributesTransformer = transformer
    }
    
    func setConfiguration(title: String? = nil,
                          scale: UIImage.SymbolScale = .small) {
        let symbol = UIImage(systemName: "arrowtriangle.down.fill", withConfiguration: UIImage.SymbolConfiguration(scale: scale))

        let imageColor = UIConfigurationColorTransformer.init { incoming in
            var outgoing = incoming
            outgoing = UIColorSet.button(.gray)
            return outgoing
        }
        
        self.configuration?.imageColorTransformer = imageColor
        self.configuration?.title = title
        self.configuration?.image = symbol
    }
}
