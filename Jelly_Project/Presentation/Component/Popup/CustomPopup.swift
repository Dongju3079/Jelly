//
//  CustomPopup.swift
//  Jelly
//
//  Created by CatSlave on 5/1/24.
//
import UIKit
import SwiftEntryKit

class CustomPopup {
    
    enum MessageType {
        case welcome
        case ageTip
        case obesityTip
        case weight
        
        var title: String {
            switch self {
            case .welcome:
                "Welcome!"
            case .ageTip, .obesityTip ,.weight:
                "TIP"
            }
        }
        
        var description: String {
            switch self {
            case .welcome:
                "반려묘의 하루 급여량을 손쉽게 계산해보세요."
            case .ageTip:
                "성장기: 12개월 이하\n\n성묘: 성장기와 고령묘 사이\n\n고령묘: 10살 이후"
            case .obesityTip:
                "마른상태: 육안으로 갈비뼈가 보여요.\n\n정상: 육안으론 보이지 않지만 갈비뼈가 만져져요.\n\n비만상태: 갈비뼈를 만지기 힘들어요."
            case .weight:
                "1. 반려묘와 함께 몸무게를 측정해요.\n\n2. 나의 몸무게를 측정해요.\n\n3. 1번 - 2번 = 반려묘 몸무게"
            }
        }
        
        var buttonTitle: String {
            switch self {
            case .welcome:
                "Do it!"
            case .ageTip, .obesityTip, .weight:
                "닫기"
            }
        }
        
        var image: UIImage {
            switch self {
            case .welcome:
                UIImage(named: "mark")!.withRenderingMode(.alwaysTemplate)
            case .ageTip, .obesityTip, .weight:
                UIImage(named: "book")!.withRenderingMode(.alwaysTemplate)
            }
        }
    }
    
    static let shared = CustomPopup()
    
    private init() { }
    
    private var alertDataSource = PopupPresets()
    
    func showCustomPopup(type: MessageType) {
  
        BasicUserDefaults.shard.firstEnter()
        guard let attributes = alertDataSource.dataSource else { return }

        let contentView = setPopup(title: type.title,
                                   titleColor: .white,
                                   description: type.description,
                                   descriptionAlignment: .center,
                                   buttonTitle: type.buttonTitle,
                                   descriptionColor: .white,
                                   buttonTitleColor: EKColor(rgb: 0x616161),
                                   buttonBackgroundColor: .white,
                                   image: type.image)
        
        SwiftEntryKit.display(entry: contentView, using: attributes)
    }
}

// MARK: - 팝업 셋팅
extension CustomPopup {
    private func setPopup(title: String,
                          titleColor: EKColor,
                          description: String,
                          descriptionAlignment: NSTextAlignment,
                          buttonTitle: String,
                          descriptionColor: EKColor,
                          buttonTitleColor: EKColor,
                          buttonBackgroundColor: EKColor,
                          image: UIImage? = nil) -> EKPopUpMessageView {
        
        var themeImage: EKPopUpMessage.ThemeImage?
        
        if let image = image {
            themeImage = EKPopUpMessage.ThemeImage(
                image: EKProperty.ImageContent(
                    image: image,
                    displayMode: EKAttributes.DisplayMode.inferred,
                    size: CGSize(width: 60, height: 60),
                    tint: titleColor,
                    contentMode: .scaleAspectFit
                )
            )
        }
        let title = EKProperty.LabelContent(
            text: title,
            style: .init(
                font: UIFont(customStyle: .bold, size: 24)!,
                color: titleColor,
                alignment: .center,
                displayMode: EKAttributes.DisplayMode.inferred
            ),
            accessibilityIdentifier: "title"
        )
        let description = EKProperty.LabelContent(
            text: description,
            style: .init(
                font: UIFont(customStyle: .medium, size: 16)!,
                color: descriptionColor,
                alignment: descriptionAlignment,
                displayMode: EKAttributes.DisplayMode.inferred
            ),
            accessibilityIdentifier: "description"
        )
        let button = EKProperty.ButtonContent(
            label: .init(
                text: buttonTitle,
                style: .init(
                    font: UIFont(customStyle: .bold, size: 16)!,
                    color: buttonTitleColor,
                    displayMode: EKAttributes.DisplayMode.inferred
                )
            ),
            backgroundColor: buttonBackgroundColor,
            highlightedBackgroundColor: buttonTitleColor.with(alpha: 0.05),
            displayMode: EKAttributes.DisplayMode.inferred,
            accessibilityIdentifier: "button"
        )
        let message = EKPopUpMessage(
            themeImage: themeImage,
            title: title,
            description: description,
            button: button) {
                SwiftEntryKit.dismiss()
        }
        return EKPopUpMessageView(with: message)
    }
}
