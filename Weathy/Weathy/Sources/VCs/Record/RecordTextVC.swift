//
//  RecordText.swift
//  Weathy
//
//  Created by DANNA LEE on 2020/12/31.
//

import UIKit

class RecordTextVC: UIViewController {
    
    //MARK: - Custom Variables
    
    let placeholder: String = "미래의 나에게 들려주고 싶은 날씨 조언을 적어주세요. (예 : 목도리를 챙길걸 그랬어.)"
    let maxWordCount: Int = 100
    var wordCount: Int = 0
    
    
    
    //MARK: - IBOutlets
    
    @IBOutlet var backBtn: UIButton!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var subTitleLabel: UILabel!
    @IBOutlet var textViewSurroundingView: UIView!
    @IBOutlet var recordTextView: UITextView!
    @IBOutlet var wordCountLabel: UILabel!
    @IBOutlet var finishBtn: UIButton!
    
    
    //MARK: - LifeCycle Methods

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpper()
        setTextField()
        textViewSetupView()
        setFinishBtn()
        
        recordTextView.delegate = self

        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    
    //MARK: - IBActions
    
    @IBAction func backBtnTap(_ sender: Any) {
        self.navigationController?.popViewController(animated: false)
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
        recordTextView.font = UIFont(name: "AppleSDGothicNeoR00", size: 16)
        wordCountLabel.text = "\(wordCount)/\(maxWordCount)"
    }
    
    func textViewSetupView() {
        if recordTextView.text == self.placeholder {
            recordTextView.font = UIFont(name: "AppleSDGothicNeoR00", size: 16)
            recordTextView.text = ""
            recordTextView.textColor = UIColor.black
        } else if recordTextView.text == "" {
            recordTextView.font = UIFont(name: "AppleSDGothicNeoR00", size: 16)
            recordTextView.text = self.placeholder
            recordTextView.textColor = UIColor.lightGray
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
            recordTextView.resignFirstResponder()
        }
        return true
    }
    
    func textViewShouldEndEditing(_ textView: UITextView) -> Bool {
        recordTextView.resignFirstResponder()
        return true
    }
}
