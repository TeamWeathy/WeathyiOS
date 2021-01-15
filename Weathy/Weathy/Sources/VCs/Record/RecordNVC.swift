//
//  RecordNVC.swift
//  Weathy
//
//  Created by 송황호 on 2021/01/13.
//

import UIKit

class RecordNVC: UINavigationController {

    static let identifier = "RecordNVC"
    
    var dateToday: CalendarDateClass?
    var dateString: String = "0000-00-00"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        sendData()

        // Do any additional setup after loading the view.
    }
    

}

extension RecordNVC {
    
    func sendData() {
        
        guard let root = self.viewControllers[0] as? RecordStartVC else {
            return
        }
        
        root.dateToday = dateToday
        root.dateString = dateString
    }
    
}
