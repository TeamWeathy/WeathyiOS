//
//  ChangeNickNameVC.swift
//  Weathy
//
//  Created by 송황호 on 2021/01/04.
//

import UIKit

class ChangeNickNameVC: UIViewController {
    //MARK: - Custom Variables
    
    //MARK: - IBOutlets
    
    @IBOutlet weak var changeButton: UIButton!
    @IBOutlet weak var nickNameTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //MARK: - LifeCycle Methods
        
    }
    
    //MARK: - Custom Methods
    
    func buttonImageChange(){
        if nickNameTextField.text == ""{
            self.changeButton.setImage(UIImage(named: "settingBtnEditUnselected"), for: .normal)
        }else{
            self.changeButton.setImage(UIImage(named: "settingBtnEditSelected"), for: .normal)
        }
    }
    //MARK: - @objc Methods


    //MARK: - IBActions

    @IBAction func backButtonDidTap(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}



