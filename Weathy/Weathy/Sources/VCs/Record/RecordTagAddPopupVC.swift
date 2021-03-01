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
    var tagIndex: Int = -1
    var tagCategory: String = "상의"
    
    var isAdded: Bool = false

    var addCount: Int = 0
    var placeholders: [String] = ["예 : 폴로반팔티, 기모레깅스, 히트텍", "예 : 폴로반팔티, 기모레깅스, 히트텍", "예 : 폴로반팔티, 기모레깅스, 히트텍", "태그 더 추가하기", "옷이 많군요?!", "혹시 더 있나요?", "옷장 구경 하고 싶네요", "웨디 사랑해줘서 고마워요 '◡'"]
    
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
    
//    override func viewWillDisappear(_ animated: Bool) {
//        self.presentingViewController?.viewWillAppear(false)
//    }
    
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
        self.isAdded = true
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "TagAdded"), object: self.isAdded)
        self.dismiss(animated: false, completion: nil)
//        self.presentingViewController?.viewWillAppear(false)
    }
    
    @IBAction func addBtnTap(_ sender: Any) {
        if tagCount < 50{
            self.callAddTagService()
        }
        else {
            showToastOnTop(message: "태그를 추가하려면 기존 태그를 삭제해주세요")
        }
        
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
        
        addBtn.isUserInteractionEnabled = true
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
        
        addBtn.isUserInteractionEnabled = false
        addBtn.makeRounded(cornerRadius: 25)
        addBtn.setTitle("추가하기", for: .normal)
        addBtn.setTitleColor(.white, for: .normal)
        addBtn.backgroundColor = .subGrey3
        addBtn.titleLabel?.font = .SDGothicSemiBold16
        addBtn.titleLabel?.lineSetting(kernValue: -0.8)
    }
    
    func callAddTagService() {
        RecordTagService.shared.addTag(userId: Int(UserDefaults.standard.string(forKey: "userId") ?? "") ?? 0, token: UserDefaults.standard.string(forKey: "token") ?? "", category: tagIndex, tagName: tagNameTextField.text!) { (networkResult) -> (Void) in
            switch networkResult {
            case .success(let data):
                print(">>> success")
                if let _ = data as? Closet {
                    self.showToastOnTop(message: "태그가 추가되었습니다.")
                    
                    /// 입력 완료 시 입력 돼있던 내용 삭제
                    self.tagNameTextField.text = ""
                    self.wordCount = 0
                    self.setTextNotExists()
                    
                    /// 이스터에그 - 한꺼번에 태그 많이 등록했을 때
                    if self.addCount < self.placeholders.count {
                        self.tagNameTextField.placeholder = self.placeholders[self.addCount]
                        self.addCount += 1
                    }
                    
                    /// 태그 개수 하나 추가, 타이틀에 반영
                    self.tagCount += 1
                    self.titleLabel.text = "\(self.tagCategory) 추가하기 (\(self.tagCount)/50)"
                }
                
            case .requestErr(let msg):
                print("requestErr")
                if let message = msg as? String {
                    print(message)
                    self.showToastOnTop(message: message)
                }
            case .pathErr:
                print("pathErr")
                self.showToastOnTop(message: "이미 등록한 옷이에요!")
            case .serverErr:
                print("serverErr")
                self.showToastOnTop(message: "잠시 후에 다시 시도해주세요!")
            case .networkFail:
                print("networkFail")
                self.showToastOnTop(message: "네트워크 상태를 확인해주세요!")
            }
        }
    }
    
}


//MARK: - UITextFieldDelegate

extension RecordTagAddPopupVC: UITextFieldDelegate {
    func checkMaxLength(textField: UITextField!, maxLength: Int) {
        if(textField.text?.count ?? 0 > maxLength) {
            textField.deleteBackward()
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

