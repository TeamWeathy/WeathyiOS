//
//  RecordText.swift
//  Weathy
//
//  Created by DANNA LEE on 2020/12/31.
//

import UIKit

class RecordTextVC: UIViewController {
    
    //MARK: - Custom Variables
    
    let placeholder: String = "예 : 오늘은 바람이 많이 불었어."
    let maxWordCount: Int = 100
    var wordCount: Int = 0
    
    
    
    //MARK: - IBOutlets
    
    @IBOutlet var backBtn: UIButton!
    @IBOutlet var dismissBtn: UIButton!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var subTitleLabel: UILabel!
    @IBOutlet var textViewSurroundingView: UIView!
    @IBOutlet var recordTextField: UITextView!
    @IBOutlet var wordCountLabel: UILabel!
    @IBOutlet var finishBtn: UIButton!
    
    
    //MARK: - LifeCycle Methods

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpper()
        setTextField()
        textViewSetupView()
        setFinishBtn()
        
        recordTextField.delegate = self

        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    
    //MARK: - IBActions
    
    @IBAction func backBtnTap(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
}

//MARK: - Style

extension RecordTextVC {
    func setUpper() {
//        backBtn.setBackgroundImage(UIImage(named: <#T##String#>), for: .normal)
//        dismissBtn.setBackgroundImage(UIImage(named: <#T##String#>), for: .normal)
        
        titleLabel.text = "오늘 날씨에 대해\n더 적고 싶은게 있으신가요?"
        titleLabel.numberOfLines = 2
        titleLabel.font = UIFont(name: "AppleSDGothicNeoSB00", size: 25)
        
        subTitleLabel.text = "무엇을 적든, 웨디는 다시 돌아와요."
        subTitleLabel.font = UIFont(name: "AppleSDGothicNeoR00", size: 16)
    }
    
    func setTextField() {
        textViewSurroundingView.layer.borderColor = UIColor(red: 0.506, green: 0.886, blue: 0.824, alpha: 1).cgColor
        textViewSurroundingView.layer.borderWidth = 1
        textViewSurroundingView.layer.cornerRadius = 15
        recordTextField.font = UIFont(name: "AppleSDGothicNeoR00", size: 16)
        wordCountLabel.text = "\(wordCount)/\(maxWordCount)"
    }
    
    func textViewSetupView() {
        if recordTextField.text == self.placeholder {
            recordTextField.font = UIFont(name: "AppleSDGothicNeoR00", size: 16)
            recordTextField.text = ""
            recordTextField.textColor = UIColor.black
        } else if recordTextField.text == "" {
            recordTextField.font = UIFont(name: "AppleSDGothicNeoR00", size: 16)
            recordTextField.text = self.placeholder
            recordTextField.textColor = UIColor.lightGray
        }
    }
    
    func setFinishBtn() {
        finishBtn.backgroundColor = UIColor.lightGray
        finishBtn.setTitle("완료", for: .normal)
        finishBtn.setTitleColor(.white, for: .normal)
        finishBtn.layer.cornerRadius = 30
    }
}


//MARK: - UITextViewDelegate

extension RecordTextVC: UITextViewDelegate {
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        textViewSetupView()
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        textViewSetupView()
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            recordTextField.resignFirstResponder()
        }
        return true
    }
    
    func textViewShouldEndEditing(_ textView: UITextView) -> Bool {
        recordTextField.resignFirstResponder()
        return true
    }
}
