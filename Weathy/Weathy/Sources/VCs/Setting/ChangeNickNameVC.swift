//
//  ChangeNickNameVC.swift
//  Weathy
//
//  Created by 송황호 on 2021/01/04.
//

import UIKit

class ChangeNickNameVC: UIViewController {
    // MARK: - Custom Variables
    
    var textCount = 0
    var isChange = false
    var nickName: String?
    
    // MARK: - IBOutlets
    
    @IBOutlet var nickLabel: SpacedLabel!
    @IBOutlet var sentenceLabel: SpacedLabel!
    
    @IBOutlet var textRadiusImage: UIImageView!
    @IBOutlet var nickNameTextField: UITextField!
    @IBOutlet var clearButton: UIButton!
    @IBOutlet var countLabel: SpacedLabel!
    @IBOutlet var totalCountLabel: SpacedLabel!
    
    @IBOutlet var changeButton: UIButton!
    @IBOutlet var changeButtonBottom: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        countLabel.text = "\(textCount)"
        clearButton.isHidden = true
        nickNameTextField.delegate = self
        nickName = UserDefaults.standard.string(forKey: "nickname")
        nickNameTextField.placeholder = nickName
        
        // MARK: - LifeCycle Methods
        
        labelFontSetting()
        keyBoardAction()
    }
    
    // MARK: - Custom Methods
    
    func labelFontSetting() {
        nickLabel.font = UIFont.SDGothicSemiBold25
        nickLabel.textColor = UIColor.mainGrey
        nickLabel.characterSpacing = -1.25
        
        sentenceLabel.font = UIFont.SDGothicRegular16
        sentenceLabel.textColor = UIColor.subGrey6
        sentenceLabel.characterSpacing = -0.8
        
        countLabel.font = UIFont.SDGothicSemiBold13
        countLabel.textColor = UIColor.subGrey6
        countLabel.characterSpacing = -0.65
        
        totalCountLabel.font = UIFont.SDGothicRegular13
        totalCountLabel.textColor = UIColor.subGrey6
        totalCountLabel.characterSpacing = -0.65
        
        changeButton.backgroundColor = UIColor.subGrey3
        changeButton.makeRounded(cornerRadius: changeButton.bounds.height / 2)
        changeButton.setTitle("변경하기", for: .normal)
        changeButton.titleLabel?.font = UIFont.SDGothicSemiBold16
        changeButton.titleLabel?.textColor = .white
    }
    
    // MARK: - @objc Methods

    // MARK: - IBActions
    
    @IBAction func backButtonDidTap(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    // TODO: BG 탭했을때, 키보드 내려오게 하기
    @IBAction func tapBG(_ sender: Any) {
        nickNameTextField.resignFirstResponder()
    }
    
    @IBAction func nickTextFieldDidTap(_ sender: Any) {
        /// 최대길이 설정
        checkMaxLength(textField: nickNameTextField, maxLength: 6)
    }
    
    /// textField 모두 지우기
    @IBAction func clearButtonDidTap(_ sender: Any) {
        if isChange == false {
            clearButton.isHidden = false
        } else {
            isChange = false
            clearButton.isHidden = true
            changeButton.backgroundColor = UIColor.subGrey3
            textRadiusImage.image = UIImage(named: "settingImgTextfieldUnselected")
            countLabel.textColor = UIColor.black
            countLabel.text = "0"
            nickNameTextField.text = ""
        }
    }
    
    /// 변경하기 눌렀을 때 Aleart
    @IBAction func changeButtonDidTap(_ sender: Any) {
        guard let nickName = nickNameTextField.text else { return }
        view.endEditing(true)
        
        modifyUserService.shared.modifyUserPut(nickname: nickName) { (NetworkResult) -> Void in
            switch NetworkResult {
            case .success(let data):
                
                if let modifyData = data as? UserData {
                    UserDefaults.standard.setValue(modifyData.user.nickname, forKey: "nickname")
                    self.nickName = modifyData.user.nickname
                    
                    self.showToast(message: "닉네임이 변경되었어요.", completion: {
                        self.navigationController?.popViewController(animated: true)
                    })
                }
            case .requestErr:
                print("requestErr")
            case .pathErr:
                print("pathErr")
            case .serverErr:
                print("serverErr")
            case .networkFail:
                print("networkFail")
            }
        }
    }
}

// MARK: - UITextFieldDelegate

extension ChangeNickNameVC: UITextFieldDelegate {
    /// textField 길이 수 재한 및 개수 count
    func checkMaxLength(textField: UITextField!, maxLength: Int) {
        if textField.text?.count ?? 0 > maxLength {
            textField.deleteBackward()
        }
        /// textField count 개수 구하기
        textCount = Int(textField.text?.count ?? 0)
        countLabel.text = "\(textCount)"
        
        /// 글자 개수에 따른 "변경하기" 버튼 이미지 변경
        if nickNameTextField.text?.count == 0 {
            isChange = false

            changeButton.backgroundColor = UIColor.subGrey3
            clearButton.isHidden = true
            countLabel.textColor = UIColor.subGrey6
        } else {
            isChange = true
            
            changeButton.backgroundColor = UIColor.mintMain
            clearButton.isHidden = false
            countLabel.textColor = UIColor.mintMain
        }
    }
}

// MARK: extension ketBoardAction

extension ChangeNickNameVC {
    func keyBoardAction() {
        // TODO: 키보드 디텍션
        NotificationCenter.default.addObserver(self, selector: #selector(adjustInputView), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(adjustInputView), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc private func adjustInputView(noti: Notification) {
        guard let userInfo = noti.userInfo else { return }
        // TODO: 키보드 높이에 따른 인풋뷰 위치 변경
        guard let keyboardFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else { return }
        if noti.name == UIResponder.keyboardWillShowNotification {
            let adjustemnHeight = keyboardFrame.height - view.safeAreaInsets.bottom
            changeButtonBottom.constant = adjustemnHeight + 16
            textRadiusImage.image = UIImage(named: "settingImgTextfieldSelected")
        } else {
            changeButtonBottom.constant = 0
            textRadiusImage.image = UIImage(named: "settingImgTextfieldUnselected")
        }
    }
}
