//
//  ModifyWeathyNVC.swift
//  Weathy
//
//  Created by DANNA LEE on 2021/01/15.
//

import UIKit

class ModifyWeathyNVC: UINavigationController {
    
    static let identifier = "ModifyWeathyNVC"
    
    var weathyData: CalendarWeathy?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        sendData()

        // Do any additional setup after loading the view.
    }

    
    

}

extension ModifyWeathyNVC {
    
    func sendData() {
        
        guard let root = self.viewControllers[0] as? ModifyWeathyStartVC else {
            return
        }
        
        root.weathyData = weathyData
    }
    
}
