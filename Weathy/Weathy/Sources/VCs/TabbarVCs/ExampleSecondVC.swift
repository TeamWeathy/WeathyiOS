//
//  ExampleSecondVC.swift
//  Weathy
//
//  Created by 송황호 on 2021/01/03.
//

import UIKit

class ExampleSecondVC: UIViewController {

    static let identifier = "ExampleSecondVC"
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    @IBAction func backPressBtn(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    

}
