//
//  Helper.swift
//  Jelly
//
//  Created by CatSlave on 3/15/24.
//

import UIKit

// MARK: - identifier
protocol ReuseIdentifiable {
    static var name: String { get }
}

extension ReuseIdentifiable {
    static var name: String {
        return String(describing: Self.self)
    }
}

extension UIViewController: ReuseIdentifiable { }
extension UITableViewCell : ReuseIdentifiable { }
extension UICollectionReusableView : ReuseIdentifiable { }


// MARK: - ProgressView Setup
extension UIProgressView {
    func setupProgressBar(_ progressBar: UIProgressView,_ before: Float, _ next: Float) {
        
        progressBar.layer.cornerRadius = 5
        progressBar.setProgress(before, animated: false)
        
        DispatchQueue.main.async {
            UIView.animate(withDuration: 1) {
                progressBar.setProgress(next, animated: true)
            }
        }
    }
}

// MARK: - 소수점 아래 자르기
extension Double {
    var clean: String {
        return String(format: "%.1f", self)
    }
}
