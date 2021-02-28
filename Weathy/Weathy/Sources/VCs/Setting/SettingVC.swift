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
    
    @IBOutlet var settingTitleLabel: SpacedLabel!
    @IBOutlet var buttonLabels: [SpacedLabel]!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setFontColor()
    }
    
    // MARK: - Custom Methods
    
    func setFontColor() {
        settingTitleLabel.font = UIFont.SDGothicSemiBold25
        settingTitleLabel.textColor = UIColor.mainGrey
        settingTitleLabel.characterSpacing = -1.25
        
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
    @IBAction func feedbackButtonDidTap(_ sender: Any) {
    }
    @IBAction func privacyButtonDidTap(_ sender: Any) {
    }
    @IBAction func locationButtonDidTap(_ sender: Any) {
    }
    @IBAction func openSourceButtonDidTap(_ sender: Any) {
    }
}
