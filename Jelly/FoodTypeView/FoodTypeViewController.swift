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
    let collectionViewSetup = TypeCollectionDataSource<FoodType>()
    var calculateModel : ResultModel?
    
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
        let itemsTitle = foodTypes.map {
            print("\($0.title)")
            return $0.title
        }
        
        collectionViewSetup.configuration(foodTypes,
                                          itemsTitle,
                                          selectedCell,
                                          foodTypeCollectionView,
                                          StatusTypeViewController.name)
        collectionViewSetup.performSegueClosure = performSegue(withIdentifier:sender:)
    }
    
    // MARK: - Selectors
    @IBAction func helpButtonTapped(_ sender: UIButton) {
        
    }
    
    fileprivate func selectedCell(_ foodType: FoodType) {
        self.calculateModel?.foodType = foodType
        print("1번 \(self.calculateModel?.foodType)")
    }
}

// MARK: - 데이터 전달
extension FoodTypeViewController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == StatusTypeViewController.name {
            let vc = segue.destination as! StatusTypeViewController
            vc.calculateModel = calculateModel
            print("2번 \(self.calculateModel?.foodType)")
        }
    }
}


