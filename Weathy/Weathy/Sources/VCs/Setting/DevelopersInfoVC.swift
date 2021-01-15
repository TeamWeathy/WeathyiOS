//
//  DevelopersInfoVC.swift
//  Weathy
//
//  Created by 송황호 on 2021/01/04.
//

import UIKit

class DevelopersInfoVC: UIViewController {
    
    //MARK: - Custom Variables
    
    //MARK: - IBOutlets

    
    //MARK: - LifeCycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    //MARK: - IBActions
    
    @IBAction func backButtonDidTap(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}
