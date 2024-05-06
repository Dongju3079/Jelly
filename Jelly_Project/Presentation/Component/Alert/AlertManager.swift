//
//  UIAlert+Ext.swift
//  Jelly
//
//  Created by CatSlave on 4/5/24.
//

import Foundation
import UIKit


class AlertManager {
    
    static let shared = AlertManager()
    
    
    private init() { }
    
    func defaultAlert(target: UIViewController,
                      title: String? = nil,
                      message: String? = nil,
                      style: UIAlertController.Style = .alert,
                      completion: ((UIAlertAction) -> Void)? = nil) {
        
        let alert = UIAlertController(title: title,
                                      message: message,
                                      preferredStyle: style)
        
        
        
        alert.addAction(UIAlertAction(title: NSLocalizedString("확인", comment: "Default action"), style: .default, handler: completion))
        
        target.present(alert, animated: true, completion: nil)
    }
}

// MARK: - 새로운 섹션 생성 얼럿
extension AlertManager {
    
    func addNameAlert(target: UIViewController,
                      completion: ((String) -> Void)? = nil) {
        print("👾 테스트 : 얼럿 설정 👾")
        let alert = UIAlertController(title: "이름 추가하기", message: "반려묘의 이름을 입력해주세요.", preferredStyle: .alert)
        alert.addTextField()
        alert.textFields?.first?.placeholder = "이름를 입력하세요."
        alert.addAction(UIAlertAction(title: NSLocalizedString("추가", comment: "Default action"), style: .default, handler: { _ in
            print(#fileID, #function, #line, "-이름생성 ")
            guard let userInput = alert.textFields?.first?.text else { return }
            
            guard !userInput.isEmpty else {
                print("👾 테스트 : 인풋이 없어요! 👾")
                return
            }
            
            guard !DataManager.shared.checkSameObject(title: userInput) else {
                print("👾 테스트 : 같은 이름이 존재해요! 👾")
                return
            }
                
            completion?(userInput)
        
        }))
        alert.addAction(UIAlertAction(title: "취소", style: .cancel))
        print("👾 테스트 : 설정 끝 👾")
        target.present(alert, animated: true, completion: nil)
    }
}


