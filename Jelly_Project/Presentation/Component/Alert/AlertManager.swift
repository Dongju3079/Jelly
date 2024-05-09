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
    
    enum InputError : Error {
        case empty
        case same
        
        var message: String {
            switch self {
            case .empty:
                "입력된 값이 없습니다."
            case .same:
                "동일한 이름이 있습니다."
            }
        }
    }
    
    #warning("하드코딩 부분 enum으로 돌려보기")
    func addNameAlert(target: UIViewController,
                      completion: ((String) -> Void)? = nil) {
        let alert = UIAlertController(title: "이름 추가하기", message: "반려묘의 이름을 입력해주세요.", preferredStyle: .alert)
        alert.addTextField()
        alert.textFields?.first?.placeholder = "이름를 입력하세요."
        alert.addAction(UIAlertAction(title: NSLocalizedString("추가", comment: "Default action"),
                                      style: .default,
                                      handler: { [weak self, weak target] _ in
            
            guard let self = self,
                  let target = target,
                  let userInput = alert.textFields?.first?.text else { return }
            
            if let error = self.checkInput(input: userInput) {
                self.defaultAlert(target: target,
                                  message: error.message) { _ in
                    self.addNameAlert(target: target, completion: completion)
                }
                return
            }
                
            completion?(userInput)
        
        }))
        
        alert.addAction(UIAlertAction(title: "취소", style: .cancel))
        target.present(alert, animated: true, completion: nil)
    }
    
    fileprivate func checkInput(input: String?) -> InputError? {
        
        guard let input = input else {
            return InputError.empty
        }
        
        guard !DataManager.shared.checkSameObject(title: input) else {
            return InputError.same
        }
        
        return nil
    }
}


