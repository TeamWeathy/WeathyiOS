//
//  MainGPSPopupVC.swift
//  Weathy
//
//  Created by 이예슬 on 2021/02/27.
//

import UIKit

class MainGPSPopupVC: UIViewController {

    //MARK: - IBOutlet
    
    @IBOutlet weak var popupView: UIView!
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var popupTitleLabel: UILabel!
    @IBOutlet weak var popupDescriptionLabel: UILabel!
    @IBOutlet weak var popupSmallerDesriptionLabel: UILabel!
    @IBOutlet weak var popupConfirmButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setStyle()
    }
    
    func setStyle(){
        backgroundView.backgroundColor = UIColor(white: 0, alpha: 0.4)
        
        popupView.makeRounded(cornerRadius: popupView.frame.height/15.86)
        
        popupTitleLabel.font = .SDGothicSemiBold20
        popupTitleLabel.textColor = .mintIcon
        
        popupDescriptionLabel.font = .SDGothicRegular16
        popupDescriptionLabel.textColor = .subGrey6
        
        popupSmallerDesriptionLabel.font = .SDGothicRegular13
        popupSmallerDesriptionLabel.textColor = .subGrey6
        
        popupConfirmButton.backgroundColor = .mintMain
        print(popupConfirmButton.frame.height/2)
        popupConfirmButton.makeRounded(cornerRadius: popupConfirmButton.bounds.height/2)
        popupConfirmButton.setTitleColor(.white, for: .normal)
        popupConfirmButton.titleLabel?.font = .SDGothicRegular16
    }
    
    @IBAction func confirmButtonDidTap(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}
