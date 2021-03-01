//
//  MainGPSPopupVC.swift
//  Weathy
//
//  Created by 이예슬 on 2021/02/27.
//

import UIKit

class MainGPSPopupVC: UIViewController {
    // MARK: - IBOutlet
    
    @IBOutlet var popupView: UIView!
    @IBOutlet var backgroundView: UIView!
    @IBOutlet var popupTitleLabel: SpacedLabel!
    @IBOutlet var popupDescriptionLabel: SpacedLabel!
    @IBOutlet var popupSmallerDesriptionLabel: UILabel!
    @IBOutlet var popupConfirmButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setStyle()
    }
    
    func setStyle() {
        backgroundView.backgroundColor = UIColor(white: 0, alpha: 0.4)
        
        popupView.makeRounded(cornerRadius: popupView.frame.height/15.86)
        popupView.dropShadow(color: UIColor(white: 39/255, alpha: 1), offSet: CGSize(width: 0, height: 3), opacity: 0.4, radius: 20)
        popupTitleLabel.font = .SDGothicSemiBold20
        popupTitleLabel.textColor = .mintIcon
        
        popupDescriptionLabel.font = .SDGothicRegular16
        popupDescriptionLabel.textColor = .subGrey6
        popupDescriptionLabel.characterSpacing = -0.8
        let attrString = NSMutableAttributedString(string: popupDescriptionLabel.text!)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 2
        attrString.addAttribute(NSAttributedString.Key.paragraphStyle, value: paragraphStyle, range: NSMakeRange(0, attrString.length))
        popupDescriptionLabel.attributedText = attrString
        
        popupSmallerDesriptionLabel.font = .SDGothicRegular13
        popupSmallerDesriptionLabel.textColor = .subGrey6
        
        popupConfirmButton.backgroundColor = .mintMain
        popupConfirmButton.makeRounded(cornerRadius: popupConfirmButton.bounds.height/2)
        popupConfirmButton.setTitleColor(.white, for: .normal)
        popupConfirmButton.titleLabel?.font = .SDGothicRegular16
    }
    
    @IBAction func confirmButtonDidTap(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}
