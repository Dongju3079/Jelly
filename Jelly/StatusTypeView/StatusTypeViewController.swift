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
    let collectionViewSetup = TypeCollectionDataSource<StatusType>()
    var calculateModel : ResultModel?
    
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
        let itemsTitle = statusTypes.map { $0.title }
        
        collectionViewSetup.configuration(statusTypes,
                                          itemsTitle,
                                          selectedCell,
                                          StatusTypeCollectionView,
                                          WeightViewController.name)
        collectionViewSetup.performSegueClosure = performSegue(withIdentifier:sender:)
    }
    
    // MARK: - Selectors
    
    
    @IBAction func helpButtonTapped(_ sender: UIButton) {
    }
    
    fileprivate func selectedCell(_ statusType: StatusType) {
        self.calculateModel?.status = statusType
    }
    
}

// MARK: - 데이터 전달
extension StatusTypeViewController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == WeightViewController.name {
            let vc = segue.destination as! WeightViewController
            vc.calculateModel = calculateModel
        }
    }
}

