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
    
    @IBOutlet weak var developersInfoLabel: UILabel!
    @IBOutlet var nameLabels: [UILabel]!    /// Name 관련
    @IBOutlet var partLalbels: [UILabel]!   /// Part 관련
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //MARK: - LifeCycle Methods
        
        textColor()
    }
    
    //MARK: - Custom Methods
    
    func textColor(){
        developersInfoLabel.font = UIFont.SDGothicSemiBold25
        
        for i in 0..<nameLabels.count {
                nameLabels[i].font = UIFont.SDGothicRegular16
                nameLabels[i].textColor = UIColor.subGrey6
        }
        for i in 0 ..< partLalbels.count {
            partLalbels[i].font = UIFont.SDGothicRegular16
            partLalbels[i].textColor = UIColor.mainGrey
        }
    }
    
    //MARK: - @objc Methods


    //MARK: - IBActions
    
    @IBAction func backButtonDidTap(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}
