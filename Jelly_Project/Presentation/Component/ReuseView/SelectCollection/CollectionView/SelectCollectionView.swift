//
//  SelectCollectionView.swift
//  Jelly
//
//  Created by CatSlave on 5/2/24.
//

import Foundation
import UIKit
import SnapKit
import Floaty

protocol FloatySelectDelegate: NSObject {
    func tapDeleteButton() -> Void
    func tapAddButton() -> Void
    func checkDeleteMode() -> Void
}

class SelectCollectionView: UIView {
    
    // MARK: - Variables
    
    private weak var floatySelectDelegate : FloatySelectDelegate?
    private let floatyInit = FloatyInit()
    
    // MARK: - UI components
    
    @IBOutlet weak var maskingView: UIView!
    @IBOutlet weak var commonView: CommonView!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var emptyLabel: UILabel!
    
    // MARK: - LifeCycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        print(#fileID, #function, #line, "- ")
        applyNib()
        setLayer()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        print(#fileID, #function, #line, "- ")
    }
    
    convenience init(enterType: EnterType) {
        
        self.init(frame: .zero)
        setCollectionView()
        self.commonView.configuration(enterType: enterType)
    }
    
    
    // MARK: - UI Setup
    
    fileprivate func applyNib(){
        print(#fileID, #function, #line, "- ")
        guard let view = findNibView() else { return }
        
        addSubview(view)
        
        view.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }

    fileprivate func setLayer() {
        containerView.layer.masksToBounds = true
        collectionView.layer.masksToBounds = false
        maskingView.addMasking()
    }
    
    fileprivate func setCollectionView() {
        collectionView.showsVerticalScrollIndicator = false

        collectionView.register(UINib.getSelectCell(), forCellWithReuseIdentifier: SelectCollectionCell.name)
    }

    // MARK: - Floty

    func setFloatyButton(delegate: FloatySelectDelegate) {
        self.floatySelectDelegate = delegate
        let floaty = floatyInit.getFloatyButton(delegate: delegate)
        floaty.fabDelegate = self
        self.addSubview(floaty)
    }
    
    // MARK: - Progress Gauge
    func downGaugeAtPop() {
        self.commonView.progressBar.downGauge()
    }
    
    // MARK: - TipButton
    func setTipButton(delegate: TipSelectDelegate) {
        self.commonView.setTipButton(tipButtonDelegate: delegate)
    }
    
    func setTipButtonTag(num: Int) {
        switch num {
        case 0, 1:
            commonView.tipButton.tag = num
        default:
            commonView.tipButton.isHidden = true   
        }
    }
    
    // MARK: - Masking
    func showMaskingView(offSet: Double) {
        maskingView.isHidden = offSet <= 20
    }
}

// MARK: - Helper
extension SelectCollectionView {
    
    fileprivate func findNibView() -> UIView? {
        let nibName = String(describing: Self.self)
        let nib = Bundle.main.loadNibNamed(nibName, owner: self)
        guard let view = nib?.first as? UIView else { return nil }
        return view
    }
}

// MARK: - Floaty
extension SelectCollectionView: FloatyDelegate {
    func floatyWillOpen(_ floaty: Floaty) {
        floatySelectDelegate?.checkDeleteMode()
    }
}
