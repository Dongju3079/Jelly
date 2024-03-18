//
//  ResultViewController.swift
//  Jelly
//
//  Created by CatSlave on 3/18/24.
//

import UIKit
import SnapKit

class ResultViewController: UIViewController {
    
    
    let customTextField = CustomTextFieldView()

    override func viewDidLoad() {
        super.viewDidLoad()
        buttonSetup()
        setupAction()
        setupNaviItem()

    }
    
    
    func buttonSetup() {
        self.view.addSubview(customTextField)
        
        customTextField.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalToSuperview().offset(100)
        }
    }
    func setupAction() {
        
        let menu = UIMenu(children: [
            UIAction(title: "1번", handler: { _ in
                print("1번 선택")
            }),
            UIAction(title: "2번", handler: { _ in
                print("2번 선택")
            }),
            UIAction(title: "3번", handler: { _ in
                print("3번 선택")
            }),
            UIAction(title: "4번", handler: { _ in
                print("4번 선택")
            })
        ])
        
        customTextField.weightButton.menu = menu
        customTextField.weightButton.showsMenuAsPrimaryAction = true
        
    }
    
    
    // MARK: - Selectors
    
    fileprivate func setupNaviItem() {
        let menu = UIMenu(children: [
            UIAction(title: "1번", handler: { _ in
                print("1번 선택")
            }),
            UIAction(title: "2번", handler: { _ in
                print("2번 선택")
            }),
            UIAction(title: "3번", handler: { _ in
                print("3번 선택")
            }),
            UIAction(title: "4번", handler: { _ in
                print("4번 선택")
            })
        ])
        
        let menuButton = UIBarButtonItem(title: "Menu", menu: menu)
        
        self.navigationItem.rightBarButtonItem = menuButton
    }
}


#if DEBUG

import SwiftUI

struct ViewController_Previews: PreviewProvider {
    static var previews: some View {
        ResultViewController().getPreview()
            .ignoresSafeArea()
    }
}

#endif
