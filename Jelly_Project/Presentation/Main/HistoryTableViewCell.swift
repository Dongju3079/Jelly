//
//  HistoryTableViewCell.swift
//  Jelly
//
//  Created by CatSlave on 3/13/24.
//

import UIKit
import Then
import SnapKit
import SwipeCellKit

class HistoryTableViewCell: SwipeTableViewCell {
    
    // MARK: - Variables
    
    var status: PetStatus? {
        didSet {
            guard let dataModel = status else { return }
            
            self.statusLabel.text = dataModel.status?.name
            self.dateLabel.text = dataModel.dateString
            let adequateCalorie = dataModel.adequateCalorie().convertString
            self.calorieLabel.text = "적정 칼로리 : \(adequateCalorie) kcal"
        }
    }
    
    // MARK: - UI components
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var subStackView: UIStackView!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var calorieLabel: UILabel!
    @IBOutlet weak var arrowButton: UIButton!
    @IBOutlet weak var borderView: UIView!
    
    
    // MARK: - LifeCycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
        setupColor()
    }
    
    // MARK: - UI Setup

    fileprivate func setupUI() {
        self.contentView.layer.masksToBounds = false
        containerView.makeShadow()
        subStackView.layer.cornerRadius = 8
    }
    
    fileprivate func setupColor() {
        [statusLabel, dateLabel].forEach {
            $0?.textColor = UIColorSet.text(.green2)
        }
        borderView.backgroundColor = UIColorSet.background(.border)
        calorieLabel.textColor = UIColorSet.text(.black)
    }
}
