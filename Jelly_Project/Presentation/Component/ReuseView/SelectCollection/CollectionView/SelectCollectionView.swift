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
    
    let floaty = Floaty()
    weak var floatySelectDelegate : FloatySelectDelegate?
    
    
    @IBOutlet weak var maskingView: UIView!
    @IBOutlet weak var commonView: CommonView!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var emptyLabel: UILabel!
    
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
    
    deinit {
        print("테스트 deinit : \(self)")
    }
    
    convenience init(enterType: EnterType) {
        
        self.init(frame: .zero)
        setCollectionView()
        self.commonView.configuration(enterType: enterType)
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
    
    func setFloatyButton(delegate: FloatySelectDelegate) {
        self.floatySelectDelegate = delegate
        floaty.hasShadow = false
        floaty.fabDelegate = self
        floaty.size = 70
        floaty.paddingY = 40
        floaty.paddingX = 20
        floaty.buttonColor = UIColorSet.button(.green)
        
        floaty.buttonImage = UIImage(named: "plus")!.withRenderingMode(.alwaysTemplate)
        floaty.plusColor = .white

        floaty.addItem("편집", icon: UIImage(named: "minus")) { [weak self] _ in
            guard let self = self else { return }
            floatySelectDelegate?.tapDeleteButton()
        }
        
        floaty.addItem("추가", icon: UIImage(named: "plus")) { [weak self] _ in
            guard let self = self else { return }
            floatySelectDelegate?.tapAddButton()
        }
        
        floaty.items.forEach {
            $0.titleLabel.font = UIFont(customStyle: .bold, size: 15)
        }
        
        self.addSubview(floaty)
    }
    
    func downGaugeAtPop() {
        self.commonView.progressBar.downGauge()
    }
    
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
    
    func showMaskingView(offSet: Double) {
        maskingView.isHidden = offSet <= -20
    }
}

extension SelectCollectionView: FloatyDelegate {
    func floatyWillOpen(_ floaty: Floaty) {
        floatySelectDelegate?.checkDeleteMode()
    }
}
