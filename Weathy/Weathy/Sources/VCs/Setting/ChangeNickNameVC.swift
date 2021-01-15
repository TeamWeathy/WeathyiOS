//
//  ChangeNickNameVC.swift
//  Weathy
//
//  Created by 송황호 on 2021/01/04.
//

import UIKit

class ChangeNickNameVC: UIViewController {
    
    //MARK: - Custom Variables
    
    var textCount = 0
    var changBool = false
    var nickName : String?
    
    //MARK: - IBOutlets
    
    @IBOutlet weak var nickLabel: UILabel!
    @IBOutlet weak var sentenceLabel: UILabel!
    
    @IBOutlet weak var textRadiusImage: UIImageView!
    @IBOutlet weak var nickNameTextField: UITextField!
    @IBOutlet weak var clearButton: UIButton!
    @IBOutlet weak var countLabel: UILabel!
    
    @IBOutlet weak var changeButton: UIButton!
    @IBOutlet weak var changeButtonBottom: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        countLabel.text = "\(textCount)"
        clearButton.isHidden = true
        nickNameTextField.delegate = self
        nickName = UserDefaults.standard.string(forKey: "nickname")
        self.nickNameTextField.placeholder = nickName
        
        //MARK: - LifeCycle Methods
        
        labelFontSetting()
        keyBoardAction()
    }
    
    //MARK: - Custom Methods
    
    func labelFontSetting(){
        nickLabel.font = UIFont.SDGothicSemiBold25
        sentenceLabel.font = UIFont.SDGothicRegular16
        sentenceLabel.textColor = UIColor.subGrey6
    }
    
    /// 변경하기 aleart  생성
    func simpleAlert() {
        let alert = UIAlertController(title: "닉네임을 변경 하시겠습니까?", message: "", preferredStyle: UIAlertController.Style.alert)
        let noButton = UIAlertAction(title: "아니요", style: UIAlertAction.Style.default, handler: nil)
        let yesButton = UIAlertAction(title: "네", style: UIAlertAction.Style.default, handler: { _ in        self.navigationController?.popViewController(animated: true)})
        
        alert.addAction(noButton)
        alert.addAction(yesButton)
        present(alert, animated: true)
    }
    
    //MARK: - @objc Methods

    //MARK: - IBActions
    
    @IBAction func backButtonDidTap(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    // TODO: BG 탭했을때, 키보드 내려오게 하기
    @IBAction func tapBG(_ sender: Any) {
        nickNameTextField.resignFirstResponder()
    }
    
    @IBAction func NickTextFieldDidTap(_ sender: Any) {
        /// 최대길이 설정
        checkMaxLength(textField: nickNameTextField, maxLength: 6)
    }
    
    /// textField 모두 지우기
    @IBAction func clearButtonDidTap(_ sender: Any) {
        if changBool == false {
            clearButton.isHidden = false
        } else {
            changBool = false
            clearButton.isHidden = true
            self.changeButton.setBackgroundImage(UIImage(named: "settingBtnEditUnselected"), for: .normal)
            self.textRadiusImage.image = UIImage(named: "settingImgTextfieldUnselected")
            countLabel.textColor = UIColor.black
            countLabel.text = "0"
            nickNameTextField.text = ""
        }
    }
    
    /// 변경하기 눌렀을 때 Aleart
    @IBAction func changeButtonDidTap(_ sender: Any) {
        
        guard let nickName = nickNameTextField.text else { return }
        
        /// 서버 연결!
        modifyUserService.shared.modifyUserPut(nickname: nickName){(NetworkResult) -> (Void) in
            switch NetworkResult{
            case .success(let data):
                
                if let modifyData = data as? UserInformation{
                    UserDefaults.standard.setValue(modifyData.user.nickname, forKey: "nickname")
                    
                    self.nickName = modifyData.user.nickname
                    
                    /// 닉네임 설정 했을 때 aleart 띄우기
                    if self.changBool == true {
                        self.simpleAlert()
                    }
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

//MARK: - UITextFieldDelegate

extension ChangeNickNameVC: UITextFieldDelegate{
    
    /// textField 길이 수 재한 및 개수 count
    func checkMaxLength(textField: UITextField!, maxLength: Int) {
        if(textField.text?.count ?? 0 > maxLength) {
            textField.deleteBackward()
        }
        /// textField count 개수 구하기
        self.textCount = Int(textField.text?.count ?? 0)
        countLabel.text = "\(textCount)"
        
        /// 글자 개수에 따른 "변경하기" 버튼 이미지 변경
        if nickNameTextField.text?.count == 0{
            self.changBool = false
            self.changeButton.setBackgroundImage(UIImage(named: "settingBtnEditUnselected"), for: .normal)
            self.changeButton.setBackgroundImage(UIImage(named: "settingImgTextfieldUnselected"), for: .normal)
            clearButton.isHidden = true
            countLabel.textColor = UIColor.black
        }else{
            self.changBool = true
            self.changeButton.setImage(UIImage(named: "settingBtnEditSelected"), for: .normal)
            self.textRadiusImage.image = UIImage(named: "settingImgTextfieldSelected")
            clearButton.isHidden = false
            countLabel.textColor = UIColor.mintMain
        }
    }
}

//MARK: extension ketBoardAction 추가

extension ChangeNickNameVC {
    
    func keyBoardAction(){
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
        }else {
            changeButtonBottom.constant = 0
        }
    }
}
