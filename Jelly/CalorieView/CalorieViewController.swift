//
//  CalorieViewController.swift
//  Jelly
//
//  Created by CatSlave on 3/15/24.
//

import UIKit
import SnapKit

class CalorieViewController: UIViewController {

    // MARK: - Variables
    
    
    // MARK: - UI components
    
    @IBOutlet weak var progressBar: UIProgressView!
    @IBOutlet weak var infoLabel: UILabel!
    let customTextField = CustomTextFieldView(type: .inputOfOneThing(useButton: true))
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        progressBar.setupProgressBar(progressBar, 0.8, 1.0)
        setupNaviItem()
        setupUI()
        setupAction()
    }
    
    // MARK: - UI Setup
    fileprivate func setupUI() {
        self.view.addSubview(customTextField)
        
        customTextField.snp.makeConstraints { make in
            make.leading.trailing.equalTo(progressBar)
            make.top.equalTo(infoLabel.snp.bottom).offset(25)
        }
    }
    
    // MARK: - Selectors
    
    fileprivate func setupNaviItem() {
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Next", style: .plain, target: self, action: #selector(nextPage))
    }
    
    @objc fileprivate func nextPage() {
        performSegue(withIdentifier: ResultViewController.name, sender: nil)
    }
    
    
    fileprivate func setupAction() {
        
        let menu = UIMenu(children: [
            UIAction(title: "Kg(단위)", handler: { _ in
                print("1번 선택")
            }),
            UIAction(title: "g(단위)", handler: { _ in
                print("2번 선택")
            })
        ])
        
        customTextField.weightButton.menu = menu
        customTextField.weightButton.showsMenuAsPrimaryAction = true
        
    }

}

