//
//  DecideStatusViewController.swift
//  Jelly
//
//  Created by CatSlave on 3/15/24.
//

import UIKit

class StatusTypeViewController: UIViewController {

    // MARK: - Variables
    var statusTypes: [StatusType] = StatusType.allCases
    let collectionViewSetup = TypeCollectionDataSource<String>()
    
    // MARK: - UI components
    
    @IBOutlet weak var progressBar: UIProgressView!
    @IBOutlet weak var StatusTypeCollectionView: UICollectionView!
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
        progressBar.setupProgressBar(progressBar, 0.4, 0.6)
    }

    
    // MARK: - UI Setup
    fileprivate func setupCollectionView() {
        let items = statusTypes.map { $0.rawValue }
        collectionViewSetup.configuration(items, StatusTypeCollectionView, WeightViewController.name)
        collectionViewSetup.performSegueClosure = performSegue(withIdentifier:sender:)
    }
    
    // MARK: - Selectors
    
    
    @IBAction func helpButtonTapped(_ sender: UIButton) {
    }
    
}

// MARK: - 데이터 전달
extension StatusTypeViewController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if segue.identifier == DecideFoodTypeViewController.name {
//            let vc = segue.destination as! DecideFoodTypeViewController
//            // 전달할 데이터
//        }
    }
}

