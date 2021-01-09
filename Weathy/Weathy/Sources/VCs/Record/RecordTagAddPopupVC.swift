//
//  RecordTagAddPopupVC.swift
//  Weathy
//
//  Created by DANNA LEE on 2021/01/09.
//

import UIKit

class RecordTagAddPopupVC: UIViewController {
    
    //MARK: - Custom Variables
    
    var tagCount: Int = 23
    var wordCount: Int = 0
    var tagCategory: String = "상의"
    
    //MARK: - @IBOutlets
    
    @IBOutlet var popupView: UIView!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var subTitleLabel: UILabel!
    @IBOutlet var textFieldView: UIView!
    @IBOutlet var tagNameTextField: UITextField!
    @IBOutlet var wordCountLabel: UILabel!
    @IBOutlet var maxWordLabel: UILabel!
    @IBOutlet var closeBtn: UIButton!
    @IBOutlet var addBtn: UIButton!
    
    
    //MARK: - Life Cycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setPopupView()
        setTextNotExists()
        
        tagNameTextField.delegate = self
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    //MARK: - @IBAction
    
    @IBAction func editChanged(_ sender: Any) {
        
        checkMaxLength(textField: tagNameTextField, maxLength: 10)
        
        if tagNameTextField.text?.count == 0 {
            setTextNotExists()
        }
        else {
            wordCount = tagNameTextField.text!.count
            setTextExists()
        }
        
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
        titleLabel.text = "\(tagCategory) 추가하기 (\(tagCount)/50)"
        
        subTitleLabel.font = UIFont.SDGothicRegular16
        subTitleLabel.textColor = UIColor.subGrey6
        subTitleLabel.lineSetting(kernValue: -0.8)
        subTitleLabel.text = "나만 알아볼 수 있는 말로\n옷을 등록해 보세요!"
        subTitleLabel.numberOfLines = 2
        
        textFieldView.makeRounded(cornerRadius: 15)
        
        tagNameTextField.font = .SDGothicRegular16
        tagNameTextField.textColor = .black
        tagNameTextField.borderStyle = .none
        tagNameTextField.placeholder = "예 : 폴로반팔티, 기모레깅스, 히트텍"
        
        closeBtn.setBorder(borderColor: .subGrey2, borderWidth: 1)
        closeBtn.makeRounded(cornerRadius: 25)
        closeBtn.setTitle("닫기", for: .normal)
        closeBtn.setTitleColor(UIColor.subGrey6, for: .normal)
        closeBtn.titleLabel?.font = .SDGothicMedium16
        closeBtn.titleLabel?.lineSetting(kernValue: -0.8)
        
    }
    
    func setTextExists() {
        
        textFieldView.setBorder(borderColor: .mintMain, borderWidth: 1)
        
        wordCountLabel.isHidden = false
        wordCountLabel.font = .SDGothicSemiBold13
        wordCountLabel.textColor = .mintIcon
        wordCountLabel.text = "\(wordCount)"
        
        maxWordLabel.isHidden = false
        maxWordLabel.font = .SDGothicRegular13
        maxWordLabel.textColor = .subGrey6
        maxWordLabel.text = "/10"
        
        addBtn.makeRounded(cornerRadius: 25)
        addBtn.setTitle("추가하기", for: .normal)
        addBtn.setTitleColor(.white, for: .normal)
        addBtn.backgroundColor = .mintMain
        addBtn.titleLabel?.font = .SDGothicSemiBold16
        addBtn.titleLabel?.lineSetting(kernValue: -0.8)
        
    }
    
    func setTextNotExists() {
        
        textFieldView.setBorder(borderColor: .subGrey7, borderWidth: 1)
        
        wordCountLabel.isHidden = true
        maxWordLabel.isHidden = true
        
        addBtn.makeRounded(cornerRadius: 25)
        addBtn.setTitle("추가하기", for: .normal)
        addBtn.setTitleColor(.white, for: .normal)
        addBtn.backgroundColor = .subGrey3
        addBtn.titleLabel?.font = .SDGothicSemiBold16
        addBtn.titleLabel?.lineSetting(kernValue: -0.8)
    }
    
}


//MARK: - UITextFieldDelegate

extension RecordTagAddPopupVC: UITextFieldDelegate {
    func checkMaxLength(textField: UITextField!, maxLength: Int) {
        if(textField.text?.count ?? 0 > maxLength) {
            textField.deleteBackward()
        }
    }
}

