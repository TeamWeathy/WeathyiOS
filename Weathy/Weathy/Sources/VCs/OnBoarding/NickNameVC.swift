//
//  NickNameVC.swift
//  Weathy
//
//  Created by 송황호 on 2021/01/12.
//

import CoreLocation
import UIKit

class NickNameVC: UIViewController {
    // MARK: - Custom Variables
    
    var textCount = 0
    var isChange = false
    
    // MARK: - IBOutlets
    
    @IBOutlet var titleLabel: SpacedLabel!
    @IBOutlet var descriptionLabel: SpacedLabel!
    
    @IBOutlet var textRadiusImage: UIImageView!
    @IBOutlet var nickNameTextField: UITextField!
    @IBOutlet var clearButton: UIButton!
    @IBOutlet var countLabel: SpacedLabel!
    @IBOutlet var totalCountLabel: SpacedLabel!
    
    @IBOutlet var startButton: UIButton!
    @IBOutlet var startButtonBottom: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        nickNameTextField.delegate = self
        
        setView()
        keyBoardAction()
    }
    
    // MARK: - Custom Methods
    
    func setView() {
        countLabel.text = "\(textCount)"
        
        clearButton.isHidden = true

        titleLabel.font = UIFont.SDGothicRegular25
        titleLabel.textColor = UIColor.mainGrey
        titleLabel.characterSpacing = -1.25
        
        descriptionLabel.font = UIFont.SDGothicRegular16
        descriptionLabel.textColor = UIColor.subGrey6
        descriptionLabel.characterSpacing = -0.65
        
        countLabel.font = UIFont.SDGothicRegular13
        countLabel.textColor = UIColor.subGrey6
        countLabel.characterSpacing = -0.65
        
        totalCountLabel.font = UIFont.SDGothicRegular13
        totalCountLabel.textColor = UIColor.subGrey6
        totalCountLabel.characterSpacing = -0.65
        
        textRadiusImage.image = UIImage(named: "settingImgTextfieldUnselected")
        
        let attr = NSMutableAttributedString(string: titleLabel.text!)
        let range = (titleLabel.text! as NSString).range(of: "닉네임")
        attr.addAttribute(NSAttributedString.Key.foregroundColor,
                          value: UIColor.mintIcon, range: range)
        attr.addAttribute(NSAttributedString.Key.font, value: UIFont.SDGothicSemiBold25, range: range)
        titleLabel.attributedText = attr
    }
    
    // MARK: - Network

    func createUser(uuid: String, nickName: String) {
        createUserService.shared.createUserPost(uuid: uuid, nickname: nickName) { (networkResult) -> Void in
            switch networkResult {
            case .success(let data):
                if let createData = data as? UserData {
                    UserDefaults.standard.set(createData.user.nickname, forKey: "nickname")
                    UserDefaults.standard.set(createData.token, forKey: "token")
                    UserDefaults.standard.set(createData.user.id, forKey: "userId")
                    UserDefaults.standard.set(uuid, forKey: "UUID")
                    
                    guard let popUpVC = self.storyboard?.instantiateViewController(withIdentifier: "NickNamePopUpVC") as? NickNamePopUpVC else { return }
                    popUpVC.modalPresentationStyle = .overCurrentContext
                    popUpVC.modalTransitionStyle = .crossDissolve
                    
                    self.present(popUpVC, animated: true, completion: nil)
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
    
    // MARK: - @objc Methods

    // MARK: - IBActions
    
    // TODO: BG 탭했을때, 키보드 내려오게 하기
    @IBAction func tapBackgroundView(_ sender: Any) {
        nickNameTextField.resignFirstResponder()
    }
    
    @IBAction func nickTextFieldDidTap(_ sender: Any) {
        checkMaxLength(textField: nickNameTextField, maxLength: 6)
    }
    
    /// textField 모두 지우기
    @IBAction func touchUpClearButton(_ sender: Any) {
        if !isChange {
            clearButton.isHidden = false
        } else {
            isChange = false
            
            clearButton.isHidden = true
            startButton.setBackgroundImage(UIImage(named: "nickname_btn_start"), for: .normal)
            countLabel.textColor = UIColor.subGrey6
            countLabel.text = "0"
            nickNameTextField.text = .none
        }
    }
    
    @IBAction func touchUpStartButton(_ sender: Any) {
        guard let nickName = nickNameTextField.text else { return }
        let uuid = UIDevice.current.identifierForVendor!.uuidString

        createUser(uuid: uuid, nickName: nickName)
    }
}

// MARK: - UITextFieldDelegate

extension NickNameVC: UITextFieldDelegate {
    /// textField 길이 수 제한 및 개수 count
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
            
            startButton.setBackgroundImage(UIImage(named: "nickname_btn_start"), for: .normal)
            clearButton.isHidden = true
            countLabel.textColor = UIColor.subGrey6
        } else {
            isChange = true
            
            startButton.setBackgroundImage(UIImage(named: "nickname_btn_start_mint"), for: .normal)
            clearButton.isHidden = false
            countLabel.textColor = UIColor.mintMain
        }
    }
}

// MARK: keyBoardAction

extension NickNameVC {
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
            startButtonBottom.constant = adjustemnHeight + 16
            
            textRadiusImage.image = UIImage(named: "settingImgTextfieldSelected")
        } else {
            startButtonBottom.constant = 16
            
            textRadiusImage.image = UIImage(named: "settingImgTextfieldUnselected")
        }
    }
}
