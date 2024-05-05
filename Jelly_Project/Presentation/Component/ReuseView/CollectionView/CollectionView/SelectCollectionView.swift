//
//  SelectCollectionView.swift
//  Jelly
//
//  Created by CatSlave on 5/2/24.
//

import Foundation
import UIKit
import SnapKit
//import Floaty

class SelectCollectionView: UIView {
    
//    private let floaty = Floaty()
    
    private var tapAddButton : (() -> Void)?
    private var tapDeleteButton : (() -> Void)?
    private var checkEditMode : (() -> Void)?
    private var tapTipButton : ((UIButton) -> Void)?
    
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
    
    convenience init(enterType: EnterType,
                     tapAddButton : (() -> Void)? = nil,
                     tapDeleteButton : (() -> Void)? = nil,
                     checkEditMode : (() -> Void)? = nil,
                     tapTipButton : ((UIButton) -> Void)? = nil) {
        
        print(#fileID, #function, #line, "- ")
        self.init(frame: .zero)
        self.tapAddButton = tapAddButton
        self.tapDeleteButton = tapDeleteButton
        self.checkEditMode = checkEditMode
        self.tapTipButton = tapTipButton
        setCollectionView()
        setCommonView(enterType)
    }
    
    fileprivate func setCommonView(_ enterType: EnterType) {
        self.commonView.configuration(enterType: enterType, tipButtonTapped: tapTipButton)
    }
    
    fileprivate func setLayer() {
        containerView.layer.masksToBounds = true
        collectionView.layer.masksToBounds = false
    }
    
    fileprivate func setCollectionView() {
        collectionView.showsVerticalScrollIndicator = false

        collectionView.register(UINib.getSelectCell(), forCellWithReuseIdentifier: SelectCollectionCell.name)
    }
    
//    func setFloaty() {
//        floaty.hasShadow = false
//        floaty.fabDelegate = self
//        floaty.size = 70
//        floaty.paddingY = 40
//        floaty.paddingX = 20
//        floaty.buttonColor = UIColorSet.button(.green)
//        
//        floaty.buttonImage = UIImage(named: "plus")!.withRenderingMode(.alwaysTemplate)
//        floaty.plusColor = .white
//
//        floaty.addItem("편집", icon: UIImage(named: "minus")) { _ in
//            self.tapDeleteButton?()
//        }
//        
//        floaty.addItem("추가", icon: UIImage(named: "plus")) { item in
//            self.tapAddButton?()
//        }
//        
//        floaty.items.forEach {
//            $0.titleLabel.font = UIFont(customStyle: .bold, size: 15)
//        }
//        
//        self.addSubview(floaty)
//    }
    
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
    
    func downGaugeAtPop() {
        self.commonView.progressBar.downGauge()
    }
    
    func setTipButtonTag(num: Int) {
        switch num {
        case 0, 1:
            commonView.tipButton.tag = num
        default:
            commonView.tipButton.isHidden = true   
        }
    }
}
//
//extension SelectCollectionView: FloatyDelegate {
//    func floatyWillOpen(_ floaty: Floaty) {
//        self.checkEditMode?()
//    }
//}
