//
//  NickNameVC.swift
//  Weathy
//
//  Created by 송황호 on 2021/01/12.
//

import UIKit

class NickNameVC: UIViewController {

    //MARK: - Custom Variables
    
    var textCount = 0
    var changBool = false
    
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
        let alert = UIAlertController(title: "닉네임을 설정 하시겠습니까?", message: "", preferredStyle: UIAlertController.Style.alert)
        let noButton = UIAlertAction(title: "아니요", style: UIAlertAction.Style.default, handler: nil)
        let yesButton = UIAlertAction(title: "네", style: UIAlertAction.Style.default, handler: { _ in
                UserDefaults.standard.set(true, forKey: "onboarding")
                let story = UIStoryboard.init(name: "Tabbar", bundle: nil)
                guard let vc = story.instantiateViewController(withIdentifier: TabbarVC.identifier) as? TabbarVC else { return }
                                        
                vc.modalPresentationStyle = .fullScreen
                self.present(vc, animated: true, completion: nil)})
        
        alert.addAction(noButton)
        alert.addAction(yesButton)
        present(alert, animated: true)
    }
    
    //MARK: - @objc Methods

    //MARK: - IBActions
    
    // TODO: BG 탭했을때, 키보드 내려오게 하기
    @IBAction func tapBG(_ sender: Any) {
        nickNameTextField.resignFirstResponder()
    }
    
    @IBAction func NickTextFieldDidTap(_ sender: Any) {
        checkMaxLength(textField: nickNameTextField, maxLength: 6)
    }
    
    /// textField 모두 지우기
    @IBAction func clearButtonDidTap(_ sender: Any) {
        if changBool == false {
            clearButton.isHidden = false
        } else {
            changBool = false
            clearButton.isHidden = true
            self.changeButton.setImage(UIImage(named: "nickname_btn_start"), for: .normal)
            self.textRadiusImage.image = UIImage(named: "settingImgTextfieldUnselected")
            countLabel.textColor = UIColor.black
            countLabel.text = "0"
            nickNameTextField.text = ""
        }
    }
    
    /// 변경하기 눌렀을 때 서버 연결 코드
    @IBAction func changeButtonDidTap(_ sender: Any) {
        
        guard let nickName = nickNameTextField.text else { return }
        
         let uuid = UUID().uuidString
        
//        let UUID : String = UUID().
        /// 서버 연결!
        createUserService.shared.createUserPost(uuid: uuid, nickname: nickName){(NetworkResult) -> (Void) in
            switch NetworkResult{
            case .success(let data):
                
                if let createData = data as? UserInformation {
                    UserDefaults.standard.set(createData.user.nickname, forKey: "nickname")
                    UserDefaults.standard.set(createData.token, forKey: "token")
                    UserDefaults.standard.set(createData.user.id, forKey: "userID")
                    UserDefaults.standard.set(uuid, forKey: "UUID")

//                    print("userID ---> \(UserDefaults.standard.string(forKey: "userID"))")
//                    print("token ---> \(UserDefaults.standard.string(forKey: "token"))")
                    
//                    print("---> 뭐니 넌\(self.changBool)")
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

extension NickNameVC: UITextFieldDelegate{
    
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
            self.changeButton.setImage(UIImage(named: "nickname_btn_start"), for: .normal)
            self.textRadiusImage.image = UIImage(named: "settingImgTextfieldUnselected")
            clearButton.isHidden = true
            countLabel.textColor = UIColor.black
        }else{
            self.changBool = true
            self.changeButton.setImage(UIImage(named: "nickname_btn_start_mint"), for: .normal)
            self.textRadiusImage.image = UIImage(named: "settingImgTextfieldSelected")
            clearButton.isHidden = false
            countLabel.textColor = UIColor.mintMain
        }
    }
}

//MARK: extension ketBoardAction 추가

extension NickNameVC {
    
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
