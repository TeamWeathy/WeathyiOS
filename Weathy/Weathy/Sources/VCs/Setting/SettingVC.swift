//
//  SettingVC.swift
//  Weathy
//
//  Created by 송황호 on 2021/01/04.
//

import UIKit

class SettingVC: UIViewController {
    // MARK: - Custom Variables
    
    // MARK: - IBOutlets
    
    @IBOutlet var setLabel: SpacedLabel!
    @IBOutlet var buttonLabels: [SpacedLabel]!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setFontColor()
    }
    
    // MARK: - Custom Methods
    
    func setFontColor() {
        setLabel.font = UIFont.SDGothicSemiBold25
        setLabel.textColor = UIColor.mainGrey
        setLabel.characterSpacing = -1.25
        
        for i in 0 ..< buttonLabels.count {
            buttonLabels[i].font = UIFont.SDGothicRegular16
            buttonLabels[i].characterSpacing = -0.8
            buttonLabels[i].textColor = UIColor.mainGrey
        }
    }
    
    // MARK: - @objc Methods
    
    // MARK: - IBActions

    @IBAction func backButtonDidTap(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}
