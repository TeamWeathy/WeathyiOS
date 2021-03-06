//
//  RecordStartPopUpVC.swift
//  Weathy
//
//  Created by DANNA LEE on 2021/02/22.
//

import UIKit

class RecordStartPopUpVC: UIViewController {

    
    //MARK: - IBOutlets
    
    @IBOutlet var popupView: UIView!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var subTitleLabel: UILabel!
    @IBOutlet var continueBtn: UIButton!
    @IBOutlet var quitBtn: UIButton!
    
    
    //MARK: - Life cycle methods
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setPopUp()
        // Do any additional setup after loading the view.
    }
    
    //MARK: - IBActions
    
    @IBAction func continueBtnTap(_ sender: Any) {
        dismiss(animated: false, completion: nil)
    }
    
    @IBAction func quitBtnTap(_ sender: Any) {
        presentingViewController?.presentingViewController?.dismiss(animated: false, completion: nil)
    }
    

}

extension RecordStartPopUpVC {
    func setPopUp() {
        popupView.makeRounded(cornerRadius: 15)
        
        titleLabel.font = .SDGothicSemiBold20
        titleLabel.textColor = .mintIcon
        titleLabel.text = "기록을 중지하고 나갈까요?"
        titleLabel.lineSetting(kernValue: -1.0)
        
        subTitleLabel.font = .SDGothicRegular16
        subTitleLabel.textColor = .subGrey6
        subTitleLabel.text = "나가면 기록 중인 내용이 사라져요."
        subTitleLabel.lineSetting(kernValue: -0.8)
        
        continueBtn.setBorder(borderColor: .subGrey2, borderWidth: 1)
        continueBtn.makeRounded(cornerRadius: continueBtn.frame.height / 2)
        continueBtn.setTitle("계속쓰기", for: .normal)
        continueBtn.setTitleColor(UIColor.subGrey6, for: .normal)
        continueBtn.titleLabel?.font = .SDGothicMedium16
        continueBtn.titleLabel?.lineSetting(kernValue: -0.8)
        
        quitBtn.setTitle("나가기", for: .normal)
        quitBtn.setTitleColor(.white, for: .normal)
        quitBtn.backgroundColor = .mintMain
        quitBtn.titleLabel?.font = .SDGothicSemiBold16
        quitBtn.titleLabel?.lineSetting(kernValue: -0.8)
        quitBtn.layer.cornerRadius = quitBtn.frame.height / 2
    }
}
