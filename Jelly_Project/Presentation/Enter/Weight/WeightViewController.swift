//
//  WeightViewController.swift
//  Jelly
//
//  Created by CatSlave on 3/15/24.
//

import UIKit

class WeightViewController: UIViewController {

    // MARK: - Variables
    private var weightArray: [Double] = []
    private var selectedWeight: String = ""
    private let dataManager = DataManager.shared
    
    // MARK: - UI components
    
    @IBOutlet weak var commonView: CommonView!
    @IBOutlet weak var pickerView: UIPickerView!
    @IBOutlet weak var selectView: UIView!
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    deinit {
        print("👾 테스트 : \(self)뷰가 해제되고 있습니다. 👾")
    }
    
    fileprivate func setupUI() {
        self.title = "몸무게 입력"
        setCommonView(.weight)
        setupNaviItem()
        setupSelectView()
        setupPickerView()
    }
    
    fileprivate func setCommonView(_ enterType: EnterType) {
        self.commonView.configuration(enterType: enterType)
        self.commonView.setTipButton(tipButtonDelegate: self)
    }
    
    fileprivate func setupPickerView() {
        setupWeightData()
        pickerView.dataSource = self
        pickerView.delegate = self
        pickerView.selectRow(49, inComponent: 0, animated: false)
    }
    
    fileprivate func setupWeightData() {
        for i in stride(from: 0.1, through: 25.0, by: 0.1) {
            weightArray.append(i.clean)
        }
    }
    
    fileprivate func setupSelectView() {
        self.selectView.layer.cornerRadius = 8
        self.selectView.clipsToBounds = true
        self.selectView.isUserInteractionEnabled = false
    }
    
    // MARK: - UI Setup
    
    fileprivate func setupNaviItem() {
        self.navigationItem.leftBarButtonItem = .getItem(mode: .left, target: self, action: #selector(popViewController))
        self.navigationItem.rightBarButtonItem = .getItem(mode: .right, target: self, action: #selector(completeAction))

    }
}

// MARK: - 화면이동

extension WeightViewController {
    
    @objc fileprivate func popViewController() {
        self.commonView.downGaugeAtPop()
        self.navigationController?.popViewController(animated: true)
    }
    
    #warning("확인버튼으로 변경")
    @objc fileprivate func completeAction() {
        guard let navigation = self.navigationController as? CustomNavigation else { return }
        navigation.pushToViewController(destinationVCCase: .calorie)
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
        label.font = UIFont(customStyle: .bold, size: 40)
        label.textColor = .black
        label.text = "\(weightArray[row])"
        return label
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.dataManager.currentDetailInfo?.weight = weightArray[row]
    }

}

extension WeightViewController: TipSelectDelegate {
    func tapTipButton(tag: Int) {
        CustomPopup.shared.showCustomPopup(type: .weight)
    }
}
