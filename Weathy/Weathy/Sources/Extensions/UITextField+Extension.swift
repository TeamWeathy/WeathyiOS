//
//  UITextField+Extension.swift
//  Weathy
//
//  Created by DANNA LEE on 2021/01/12.
//

import UIKit

extension UITextField {
    func lineSetting(kernValue: Double = -0.8, lineSpacing: CGFloat = 0.0, lineHeightMultiple: CGFloat = 0.0) {
        
        guard let labelText = self.text else { return }
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = lineSpacing
        paragraphStyle.lineHeightMultiple = lineHeightMultiple
        var attributedString = NSMutableAttributedString(string: labelText)
        if let labelattributedText = self.attributedText {
            attributedString = NSMutableAttributedString(attributedString: labelattributedText)
            attributedString.addAttribute(NSAttributedString.Key.kern, value: kernValue, range: NSRange(location: 0, length: attributedString.length - 1))
        } else {
            attributedString = NSMutableAttributedString(string: labelText)
        }
        
        // (Swift 4.2 and above) Line spacing attribute
        attributedString.addAttribute(NSAttributedString.Key.paragraphStyle, value:paragraphStyle, range:NSMakeRange(0, attributedString.length))
        
        self.attributedText = attributedString
    }
}
