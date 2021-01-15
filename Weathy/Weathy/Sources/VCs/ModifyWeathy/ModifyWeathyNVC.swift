//
//  ModifyWeathyNVC.swift
//  Weathy
//
//  Created by DANNA LEE on 2021/01/15.
//

import UIKit

class ModifyWeathyNVC: UINavigationController {
    
    static let identifier = "ModifyWeathyNVC"
    
    var dateString: String = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        
        sendData()

        // Do any additional setup after loading the view.
    }

    
    

}

extension ModifyWeathyNVC {
    
    func sendData() {
        guard let root = self.storyboard?.instantiateViewController(identifier: "ModifyWeathyStartVC") as? ModifyWeathyStartVC else {
            return
        }
        
        root.fullDate = dateString
    }
    
}
