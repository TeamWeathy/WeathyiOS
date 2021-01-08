//
//  RecordTagAddPopupVC.swift
//  Weathy
//
//  Created by DANNA LEE on 2021/01/09.
//

import UIKit

class RecordTagAddPopupVC: UIViewController {
    
    
    var tagCount: Int = 23
    var wordCount: Int = 0
    
    
    @IBOutlet var popupView: UIView!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var subTitleLabel: UILabel!
    @IBOutlet var textFieldView: UIView!
    @IBOutlet var tagNameTextField: UITextField!
    @IBOutlet var wordCountLabel: UILabel!
    @IBOutlet var maxWordLabel: UILabel!
    @IBOutlet var closeBtn: UIButton!
    @IBOutlet var addBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setPopupView()
        
        
    }
    
    @IBAction func closeBtnTap(_ sender: Any) {
        self.dismiss(animated: false, completion: nil)
    }
    
    @IBAction func addBtnTap(_ sender: Any) {
        self.dismiss(animated: false, completion: nil)
    }
}

//MARK: - Style

extension RecordTagAddPopupVC {
    func setPopupView() {
        popupView.makeRounded(cornerRadius: 15)
        
        titleLabel.font = UIFont.SDGothicSemiBold18
        titleLabel.textColor = UIColor.mintIcon
        titleLabel.lineSetting(kernValue: -0.9)
        titleLabel.text = "상의 추가하기 (\(tagCount)/50)"
        
        subTitleLabel.font = UIFont.SDGothicRegular16
        subTitleLabel.textColor = UIColor.subGrey6
        subTitleLabel.lineSetting(kernValue: -0.8)
        subTitleLabel.text = "나만 알아볼 수 있는 말로\n옷을 등록해 보세요!"
        subTitleLabel.numberOfLines = 2
        
        textFieldView.setBorder(borderColor: .mintMain, borderWidth: 1)
        textFieldView.makeRounded(cornerRadius: 15)
        
        tagNameTextField.font = .SDGothicRegular16
        tagNameTextField.textColor = .black
        tagNameTextField.borderStyle = .none
        
        wordCountLabel.font = .SDGothicSemiBold13
        wordCountLabel.textColor = .mintIcon
        wordCountLabel.text = "\(wordCount)"
        
        maxWordLabel.font = .SDGothicRegular13
        maxWordLabel.textColor = .subGrey6
        maxWordLabel.text = "/10"
        
        closeBtn.setBorder(borderColor: .subGrey2, borderWidth: 1)
        closeBtn.makeRounded(cornerRadius: 25)
        closeBtn.setTitle("닫기", for: .normal)
        closeBtn.setTitleColor(UIColor.black, for: .normal)
        closeBtn.titleLabel?.font = .SDGothicMedium16
        closeBtn.titleLabel?.lineSetting(kernValue: -0.8)
        
        addBtn.makeRounded(cornerRadius: 25)
        addBtn.setTitle("추가하기", for: .normal)
        addBtn.setTitleColor(.white, for: .normal)
        addBtn.backgroundColor = .mintMain
        addBtn.titleLabel?.font = .SDGothicSemiBold16
        addBtn.titleLabel?.lineSetting(kernValue: -0.8)
 
    }
    
    
    
}
