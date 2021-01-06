//
//  CalendarVC.swift
//  Weathy
//
//  Created by 이예슬 on 2020/12/31.
//

import UIKit

class CalendarDetailVC: UIViewController {
    
    //MARK: - Custom Properties
    let screen = UIScreen.main.bounds
    //MARK: - IBOutlets
    
    @IBOutlet weak var detailEmptyImageView: UIImageView!
    
    //MARK: - Lifecycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let calendarVC = self.storyboard?.instantiateViewController(identifier: "CalendarVC") as? CalendarVC else{
            return
        }
        self.addChild(calendarVC)
        self.view.addSubview(calendarVC.view)
        calendarVC.didMove(toParent: self)
        calendarVC.view.backgroundColor = .clear
        
        let height = view.frame.height
        let width = view.frame.width
        
        calendarVC.view.frame = CGRect(x: 0, y: 0, width: width, height: height)

    }
    //MARK: - Custom Methods
    
    
    //MARK: - IBActions
    

}
