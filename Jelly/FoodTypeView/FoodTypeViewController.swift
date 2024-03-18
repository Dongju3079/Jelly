//
//  DecideNameViewController.swift
//  Jelly
//
//  Created by CatSlave on 3/15/24.
//

import UIKit

class FoodTypeViewController: UIViewController {

    // MARK: - Variables
    var foodTypes: [FoodType] = FoodType.allCases
    let collectionViewSetup = TypeCollectionDataSource<String>()
    
    // MARK: - UI components
    
    @IBOutlet weak var progressBar: UIProgressView!
    @IBOutlet weak var foodTypeCollectionView: UICollectionView!
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
        progressBar.setupProgressBar(progressBar, 0.2, 0.4)
    }
    
    // MARK: - UI Setup
    fileprivate func setupCollectionView() {
        let items = foodTypes.map { $0.rawValue }
        collectionViewSetup.configuration(items, foodTypeCollectionView, StatusTypeViewController.name)
        collectionViewSetup.performSegueClosure = performSegue(withIdentifier:sender:)
    }
    
    // MARK: - Selectors
    @IBAction func helpButtonTapped(_ sender: UIButton) {
        
    }
}

// MARK: - 데이터 전달
extension FoodTypeViewController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == StatusTypeViewController.name {
            let vc = segue.destination as! StatusTypeViewController
            
        }
    }
}


