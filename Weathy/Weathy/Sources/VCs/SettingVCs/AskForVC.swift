//
//  AskForVC.swift
//  Weathy
//
//  Created by 송황호 on 2021/01/04.
//

import UIKit

class AskForVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    @IBAction func backButtonDidTap(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
}
