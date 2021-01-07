//
//  ExampleFirstVC.swift
//  Weathy
//
//  Created by 송황호 on 2021/01/03.
//

import UIKit

class ExampleFirstVC: UIViewController {
    //MARK: - Custom Variables
    
    static let identifier = "ExampleFirstVC"
    
    //MARK: - LifeCycle Methods

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setGradientView()
    }

    //MARK: - Custom Methods
        
    //MARK: - IBActions
    
    /// 설정 버튼 눌렀을 때
    @IBAction func settingButtonDidTap(_ sender: Any) {
        let storyB = UIStoryboard.init(name: "Setting", bundle: nil)
        
        guard let vc = storyB.instantiateViewController(withIdentifier: "SettingNVC") as? SettingNVC else {return}

        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true, completion: nil)
    }
}


