//
//  HistoryTableViewCell.swift
//  Jelly
//
//  Created by CatSlave on 3/13/24.
//

import UIKit

class HistoryTableViewCell: UITableViewCell {
    
    @IBOutlet weak var dateLabel: UILabel!

    @IBOutlet weak var labelStackView: UIStackView!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        labelStackView.layer.cornerRadius = 8
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        // 셀과 셀 사이의 공간 만들기
        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 0, left: 0, bottom: 10, right: 0))
    }

}
