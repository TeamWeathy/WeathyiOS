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
    var nickname: String?
    
    // MARK: - IBOutlets
    
    @IBOutlet var titleLabel: SpacedLabel!
    @IBOutlet var sentenceLabel: SpacedLabel!
    @IBOutlet var textRadiusImage: UIImageView!
    @IBOutlet var nicknameTextField: UITextField!
    @IBOutlet var clearButton: UIButton!
    @IBOutlet var countLabel: SpacedLabel!
    @IBOutlet var totalCountLabel: SpacedLabel!
    @IBOutlet var changeButton: UIButton!
    
    // MARK: - Life Cycle Methods
    
    override func viewWillAppear(_ animated: Bool) {
        nicknameTextField.becomeFirstResponder()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        nicknameTextField.delegate = self

        initView()
        keyBoardAction()
    }
    
    // MARK: - Custom Methods
    
    func initView() {
        clearButton.isHidden = true
        changeButton.isEnabled = false
        
        nickname = UserDefaults.standard.string(forKey: "nickname")
        nicknameTextField.placeholder = nickname
        
        titleLabel.font = UIFont.SDGothicSemiBold25
        titleLabel.textColor = UIColor.mainGrey
        titleLabel.characterSpacing = -1.25
        
        sentenceLabel.font = UIFont.SDGothicRegular16
        sentenceLabel.textColor = UIColor.subGrey6
        sentenceLabel.characterSpacing = -0.8
        
        countLabel.font = UIFont.SDGothicRegular13
        countLabel.textColor = UIColor.subGrey6
        countLabel.characterSpacing = -0.65
        countLabel.text = "\(textCount)"
        
        totalCountLabel.font = UIFont.SDGothicRegular13
        totalCountLabel.textColor = UIColor.subGrey6
        totalCountLabel.characterSpacing = -0.65
        
        changeButton.layoutIfNeeded()
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
    @IBAction func tapBackgroundView(_ sender: Any) {
        nicknameTextField.resignFirstResponder()
    }
    
    @IBAction func nicknameTextFieldDidTap(_ sender: Any) {
        /// 최대길이 설정
        checkMaxLength(textField: nicknameTextField, maxLength: 6)
    }
    
    /// textField 모두 지우기
    @IBAction func clearButtonDidTap(_ sender: Any) {
        clearButton.isHidden = true
        changeButton.isEnabled = false
        changeButton.backgroundColor = UIColor.subGrey3
        
        countLabel.textColor = UIColor.subGrey6
        countLabel.font = .SDGothicRegular13
        countLabel.text = "0"
        
        nicknameTextField.text?.removeAll()
    }
    
    /// 변경하기 눌렀을 때 Aleart
    @IBAction func changeButtonDidTap(_ sender: Any) {
        view.endEditing(true)
        
        guard let changedNickname = nicknameTextField.text else { return }
        
        modifyUserService.shared.modifyUserPut(nickname: changedNickname) { (NetworkResult) -> Void in
            switch NetworkResult {
            case .success(let data):
                NotificationCenter.default.post(name: Notification.Name("changeNickname"), object: nil)
                
                if let modifyData = data as? UserData {
                    UserDefaults.standard.setValue(modifyData.user.nickname, forKey: "nickname")
                    self.nickname = modifyData.user.nickname
                    
                    self.navigationController?.popViewController(animated: true)
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
        if nicknameTextField.text?.count == 0 {
            changeButton.backgroundColor = UIColor.subGrey3
            changeButton.isEnabled = false
            clearButton.isHidden = true
            
            countLabel.textColor = UIColor.subGrey6
            countLabel.font = .SDGothicRegular13
        } else {
            changeButton.backgroundColor = UIColor.mintMain
            changeButton.isEnabled = true
            clearButton.isHidden = false
            
            countLabel.textColor = UIColor.mintIcon
            countLabel.font = .SDGothicSemiBold13
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
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
        if noti.name == UIResponder.keyboardWillShowNotification {
            textRadiusImage.image = UIImage(named: "settingImgTextfieldSelected")
            
            countLabel.isHidden = false
            totalCountLabel.isHidden = false
        } else {
            textRadiusImage.image = UIImage(named: "settingImgTextfieldUnselected")
            
            countLabel.isHidden = true
            totalCountLabel.isHidden = true
        }
    }
}
