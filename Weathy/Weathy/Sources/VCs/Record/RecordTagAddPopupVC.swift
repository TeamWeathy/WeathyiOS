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
    var placeholders: [String] = ["예 : 폴로반팔티, 기모레깅스 등", "예 : 폴로반팔티, 기모레깅스 등", "예 : 폴로반팔티, 기모레깅스 등", "태그 더 추가하기", "옷이 많군요?!", "혹시 더 있나요?", "옷장 구경 하고 싶네요", "웨디 사랑해줘서 고마워요 '◡'"]
    
    //MARK: - @IBOutlets
    
    @IBOutlet var popupView: UIView!
    @IBOutlet var titleLabel: SpacedLabel!
    @IBOutlet var subTitleLabel: SpacedLabel!
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
        tagNameTextField.defaultTextAttributes.updateValue(-0.8,
            forKey: NSAttributedString.Key.kern)
        
        keyBoardAction()
        textFieldView.setBorder(borderColor: .mintMain, borderWidth: 1)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        tagNameTextField.becomeFirstResponder()
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
        if tagCount < 100{
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
        titleLabel.text = "\(tagCategory) 추가하기 (\(tagCount)/100)"
        
        subTitleLabel.font = UIFont.SDGothicRegular16
        subTitleLabel.textColor = UIColor.subGrey6
        subTitleLabel.lineSetting(kernValue: -0.8)
        subTitleLabel.text = "나만 알아볼 수 있는 말로\n옷을 등록해 보세요!"
        subTitleLabel.numberOfLines = 2
        
        textFieldView.makeRounded(cornerRadius: 15)
        
        tagNameTextField.font = .SDGothicRegular16
        tagNameTextField.textColor = .black
        tagNameTextField.borderStyle = .none
        tagNameTextField.placeholder = "예 : 폴로반팔티, 기모레깅스 등"
        
        closeBtn.setBorder(borderColor: .subGrey2, borderWidth: 1)
        closeBtn.setTitle("닫기", for: .normal)
        closeBtn.setTitleColor(UIColor.subGrey6, for: .normal)
        closeBtn.titleLabel?.font = .SDGothicMedium16
        closeBtn.titleLabel?.lineSetting(kernValue: -0.8)
        
        self.view.layoutIfNeeded()
        closeBtn.layer.cornerRadius = closeBtn.frame.height / 2
        
    }
    
    func setTextExists() {
        
        wordCountLabel.font = .SDGothicSemiBold13
        wordCountLabel.textColor = .mintIcon
        wordCountLabel.text = "\(wordCount)"
        
        addBtn.isUserInteractionEnabled = true
        addBtn.setTitle("추가하기", for: .normal)
        addBtn.setTitleColor(.white, for: .normal)
        addBtn.backgroundColor = .mintMain
        addBtn.titleLabel?.font = .SDGothicSemiBold16
        addBtn.titleLabel?.lineSetting(kernValue: -0.8)
        addBtn.layer.cornerRadius = addBtn.frame.height / 2
        
    }
    
    func setTextNotExists() {
        
        maxWordLabel.font = .SDGothicRegular13
        maxWordLabel.textColor = .subGrey6
        maxWordLabel.text = "/10"
        wordCountLabel.text = "0"
        wordCountLabel.textColor = .subGrey6
        wordCountLabel.font = .SDGothicRegular13
        
        addBtn.isUserInteractionEnabled = false
        addBtn.setTitle("추가하기", for: .normal)
        addBtn.setTitleColor(.white, for: .normal)
        addBtn.backgroundColor = .subGrey3
        addBtn.titleLabel?.font = .SDGothicSemiBold16
        addBtn.titleLabel?.lineSetting(kernValue: -0.8)
        addBtn.layer.cornerRadius = addBtn.frame.height / 2
    }
    
    func callAddTagService() {
        RecordTagService.shared.addTag(userId: Int(UserDefaults.standard.string(forKey: "userId") ?? "") ?? 0, token: UserDefaults.standard.string(forKey: "token") ?? "", category: tagIndex, tagName: tagNameTextField.text!) { (networkResult) -> (Void) in
            switch networkResult {
            case .success(let data):
                print(">>> success")
                if let _ = data as? Closet {
                    self.showToastOnTop(message: "태그가 추가되었어요!")
                    
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
                    self.titleLabel.text = "\(self.tagCategory) 추가하기 (\(self.tagCount)/100)"
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
    
    func keyBoardAction() {
        // TODO: 키보드 디텍션
        NotificationCenter.default.addObserver(self, selector: #selector(adjustInputView), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(adjustInputView), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc private func adjustInputView(noti: Notification) {
        // TODO: 키보드 높이에 따른 인풋뷰 위치 변경
        if noti.name == UIResponder.keyboardWillShowNotification {
            textFieldView.setBorder(borderColor: .mintMain, borderWidth: 1)
            
            wordCountLabel.isHidden = false
            maxWordLabel.isHidden = false
        } else {
            textFieldView.setBorder(borderColor: .subGrey7, borderWidth: 1)
            
            wordCountLabel.isHidden = true
            maxWordLabel.isHidden = true
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
}

