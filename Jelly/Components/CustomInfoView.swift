//
//  CustomInfoView.swift
//  Jelly
//
//  Created by CatSlave on 3/18/24.
//

import UIKit
import SnapKit
import Then

class CustomInfoView: UIView {
    
    private let mainTitleLabel = UILabel().then {
        $0.font = .boldSystemFont(ofSize: 25)
        $0.textColor = .label
    }
    
    private let mainSubLabel = UILabel().then {
        $0.font = .boldSystemFont(ofSize: 15)
        $0.textColor = .label
    }
    
    private let secondTitleLabel = UILabel().then {
        $0.font = .boldSystemFont(ofSize: 20)
        $0.textColor = .label
    }
    
    private let secondSubLabel = UILabel().then {
        $0.font = .boldSystemFont(ofSize: 15)
        $0.textColor = .label
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.configuration()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupText(_ mainTitle: String?,
                     _ mainSub: String?,
                     _ secondTitle: String?,
                     _ secondSub: String?) {
        
        self.mainTitleLabel.text = mainTitle
        self.mainSubLabel.text = mainSub
        self.secondTitleLabel.text = secondTitle
        self.secondSubLabel.text = secondSub
    }
    
    
    fileprivate func configuration() {
        self.addSubviews([mainTitleLabel, mainSubLabel,
                         secondTitleLabel, secondSubLabel])
        
        mainTitleLabel.snp.makeConstraints { make in
            make.leading.top.equalToSuperview()
        }
        
        mainSubLabel.snp.makeConstraints { make in
            make.leading.equalTo(mainTitleLabel.snp.trailing).offset(5)
            make.bottom.equalTo(mainTitleLabel.snp.bottom).offset(-2)
        }
        
        secondTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(mainTitleLabel.snp.bottom)
            make.leading.bottom.equalToSuperview()
        }
        
        secondSubLabel.snp.makeConstraints { make in
            make.leading.equalTo(secondTitleLabel.snp.trailing).offset(5)
            make.bottom.equalTo(secondTitleLabel.snp.bottom)
        }
        
    }
    
    
}


#if DEBUG

import SwiftUI

struct CustomInfoView_Previews: PreviewProvider {
    static var previews: some View {
        CustomInfoView()
            .getPreview()
            .previewLayout(.sizeThatFits)
            .frame(width: 350, height: 50)
    }
    
}

#endif
