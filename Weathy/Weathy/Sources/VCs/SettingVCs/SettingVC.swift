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
    @IBOutlet var buttonLabels: [UILabel]!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //MARK: - LifeCycle Methods
        
        fontColorSeting()
    }
    
    //MARK: - Custom Methods
    
    func fontColorSeting(){
        setLabel.font = UIFont.SDGothicSemiBold25
        for i in 0 ..< buttonLabels.count {
            buttonLabels[i].font = UIFont.SDGothicRegular16
        }
        switchButton.onTintColor = UIColor.mintMain
    }
    
    //MARK: - @objc Methods
    
    
    //MARK: - IBActions

    @IBAction func backButtonDidTap(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}
