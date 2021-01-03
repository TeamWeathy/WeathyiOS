//
//  SettingVC.swift
//  Weathy
//
//  Created by 송황호 on 2021/01/04.
//

import UIKit

class SettingVC: UIViewController {
    
    //MARK: - Custom Variables
    
    //MARK: - IBOutlets
    
    @IBOutlet weak var setLabel: UILabel!
    @IBOutlet weak var switchButton: UISwitch!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setLabel.font = UIFont.SDGothicSemiBold25
        switchButton.onTintColor = UIColor.mintMain
        
        //MARK: - LifeCycle Methods
        
    }
    
    //MARK: - Custom Methods
    
    
    //MARK: - @objc Methods


    //MARK: - IBActions

    @IBAction func backButtonDidTap(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}
