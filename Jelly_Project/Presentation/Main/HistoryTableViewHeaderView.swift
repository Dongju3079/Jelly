//
//  HistoryTableHeaderView.swift
//  Jelly
//
//  Created by CatSlave on 3/27/24.
//

import UIKit
import SnapKit
import Then

class HistoryTableViewHeaderView: UITableViewHeaderFooterView {

    // MARK: - UI components
    
    private let label = UILabel().then {
        $0.textColor = .label
        $0.textAlignment = .left
        $0.font = .systemFont(ofSize: 30, weight: .bold)
        $0.textColor = UIColorSet.text(.green3)
        $0.backgroundColor = .clear
        $0.text = "이름없음"
    }
    
    // MARK: - LifeCycle
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UI Setup

    fileprivate func configureUI() {
        self.contentView.addSubview(label)
        
        label.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    func setTitle(_ title: String?) {
        self.label.text = title
    }
}
