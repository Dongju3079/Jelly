//
//  WeightViewController.swift
//  Jelly
//
//  Created by CatSlave on 3/15/24.
//

import UIKit

class WeightViewController: UIViewController {

    // MARK: - Variables
    fileprivate var weightArray: [String] = []
    fileprivate var selectedWeight: String = ""
    
    // MARK: - UI components
    @IBOutlet weak var progressBar: UIProgressView!
    @IBOutlet weak var pickerView: UIPickerView!
        
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupWeight()
        setupNaviItem()
        pickerView.dataSource = self
        pickerView.delegate = self
        progressBar.setupProgressBar(progressBar, 0.6, 0.8)
        pickerView.selectRow(50, inComponent: 0, animated: false)
    }
    
    fileprivate func setupWeight() {
        for i in stride(from: 0.1, through: 25.0, by: 0.1) {
            weightArray.append(i.clean)
        }
    }
    
    // MARK: - UI Setup
    
    fileprivate func setupNaviItem() {
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Next", style: .plain, target: self, action: #selector(nextPage))
    }
    
    @objc fileprivate func nextPage() {
        performSegue(withIdentifier: CalorieViewController.name, sender: nil)
    }

}

extension WeightViewController: UIPickerViewDataSource, UIPickerViewDelegate {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return weightArray.count
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 80
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int,
                    reusing view: UIView?) -> UIView {
        let label = UILabel()
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 30)
        label.textColor = .label
        label.text = weightArray[row]
        return label
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedWeight = weightArray[row]
    }

}
