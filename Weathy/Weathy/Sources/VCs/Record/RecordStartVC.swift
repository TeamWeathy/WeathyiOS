//
//  RecordStartVC.swift
//  Weathy
//
//  Created by DANNA LEE on 2020/12/31.
//

import UIKit

class RecordStartVC: UIViewController {

    //MARK: - IBOutlets
    
    @IBOutlet var dismissBtn: UIButton!
    @IBOutlet var titleLabel: UILabel!
    
    
    
    //MARK: - LifeCycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setView()

        // Do any additional setup after loading the view.
    }
    

   

}

//MARK: - Style

extension RecordStartVC {
    func setView() {
        dismissBtn.tintColor = UIColor(red: 86/255, green: 109/255, blue: 106/255, alpha: 1)
        
        titleLabel.text = "오늘의 웨디를 기록해볼까요?"
        titleLabel.font = UIFont(name: "Apple", size: <#T##CGFloat#>)
    }
}
