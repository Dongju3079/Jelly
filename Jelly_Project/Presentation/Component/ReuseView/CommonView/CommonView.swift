//
//  CommonTopView.swift
//  Jelly
//
//  Created by CatSlave on 5/2/24.
//

import Foundation
import UIKit
import SnapKit

protocol TipSelectDelegate: NSObject {
    func tapTipButton(tag: Int) -> Void
}

class CommonView: UIView {
    
    weak var tipButtonDelegate: TipSelectDelegate?
    
    @IBOutlet weak var progressBar: CustomProgressBar!
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var tipButton: UIButton!


    override func awakeFromNib() {
        super.awakeFromNib()
        applyNib()
    }
    
    func configuration(enterType: EnterType) {
        
        progressBar.raiseGauge(enterType: enterType)
        titleLabel.text = enterType.title
        
    }
    
    func setTipButton(tipButtonDelegate: TipSelectDelegate) {
        self.tipButton.isHidden = false
        self.tipButtonDelegate = tipButtonDelegate
    }
    
    fileprivate func applyNib(){
        print(#fileID, #function, #line, "- ")
        guard let view = findNibView() else { return }
        
        addSubview(view)
        
        view.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    fileprivate func findNibView() -> UIView? {
        let nibName = String(describing: Self.self)
        let nib = Bundle.main.loadNibNamed(nibName, owner: self)
        guard let view = nib?.first as? UIView else { return nil }
        return view
    }
    
    func setCalorieViewInfoLabel(_ feedType: FoodType) {
        switch feedType {
        case .wet:
            self.titleLabel.text = "한 캔의 칼로리를 입력하세요."
        case .dry:
            self.titleLabel.text = "단위에 맞춰서 칼로리를 입력하세요."
        case .mix:
            self.titleLabel.text = "칼로리를 입력하세요."
        }
    }
    
    func downGaugeAtPop() {
        self.progressBar.downGauge()
    }
    
    @IBAction func tipButtonTapped(_ sender: UIButton) {
        tipButtonDelegate?.tapTipButton(tag: sender.tag)
    }
    
}
