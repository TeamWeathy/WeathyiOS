//
//  CalendarPartialVC.swift
//  Weathy
//
//  Created by 이예슬 on 2020/12/31.
//

import UIKit

class CalendarVC: UIViewController {
    
    //MARK: - Custom Properties
    
    //MARK: - IBOutlets
    
    @IBOutlet weak var calendarDrawerView: UIView!
    @IBOutlet weak var yearMonthTextView: UITextView!
    
    //MARK: - Lifecycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setStyle()
    }
    
    //MARK: - Custom Methods
    
    func setStyle(){
        yearMonthTextView.font = UIFont(name: "Roboto-Medium", size: 25)
        yearMonthTextView.textColor = .mainGrey
    }
    
    //MARK: - IBActions
    
    @IBAction func todayButtonDidTap(_ sender: Any) {
    }
    
}
