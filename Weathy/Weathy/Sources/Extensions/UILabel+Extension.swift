//
//  UILabel+Extension.swift
//  Weathy
//
//  Created by DANNA LEE on 2021/01/09.
//

import UIKit

// MARK: lineSetting for UILabel

// Extension 설명: UILabel의 text가 lineSpacing 또는 letterSpacing 이 있을 때 사용합니다! 총 UITextField, UILabel, UITextView 세가지 종류에 따라 똑같은 Extension이 만들어져 있습니다. 사용에 따라 kernValue만, 또는 lineSpacing만 넣을 수도 있습니다!

// 사용법: MyLabel.lineSetting(kernValue: -0.8, lineSpacing: 10)

extension UILabel {
    
    func lineSetting(kernValue: Double = 1.15, lineSpacing: CGFloat = 0.0, lineHeightMultiple: CGFloat = 0.0) {
        
        guard let labelText = self.text else { return }
        
//        let paragraphStyle = NSMutableParagraphStyle()
//        paragraphStyle.lineSpacing = lineSpacing
//        paragraphStyle.lineHeightMultiple = lineHeightMultiple
//        paragraphStyle.alignment = .center
//        var attributedString = NSMutableAttributedString(string: labelText)
//        if let labelattributedText = self.attributedText {
//            attributedString = NSMutableAttributedString(attributedString: labelattributedText)
//            attributedString.addAttribute(NSAttributedString.Key.kern, value: kernValue, range: NSRange(location: 0, length: attributedString.length - 1))
//        } else {
//            attributedString = NSMutableAttributedString(string: labelText)
//        }
        
        // (Swift 4.2 and above) Line spacing attribute
//        attributedString.addAttribute(NSAttributedString.Key.paragraphStyle, value:paragraphStyle, range:NSMakeRange(0, attributedString.length))
//
//        self.attributedText = attributedString
    }
}
