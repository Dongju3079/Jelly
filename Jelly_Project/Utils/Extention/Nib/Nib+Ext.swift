//
//  Nib+Ext.swift
//  Jelly
//
//  Created by CatSlave on 5/2/24.
//

import Foundation
import UIKit

extension UINib {
    static func getSelectCell() -> Self {
        return Self(nibName: SelectCollectionCell.name, bundle: Bundle.main)
    }
}
