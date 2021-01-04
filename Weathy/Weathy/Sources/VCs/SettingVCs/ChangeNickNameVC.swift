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
    
    //MARK: - IBOutlets
    
    @IBOutlet weak var changeButton: UIButton!
    @IBOutlet weak var changeButtonBottom: NSLayoutConstraint!
    @IBOutlet weak var nickNameTextField: UITextField!
    @IBOutlet weak var countLabel: UILabel!
    @IBOutlet weak var textRadiusImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        countLabel.text = "\(textCount)"
        
        nickNameTextField.delegate = self
        
        //MARK: - LifeCycle Methods
        
        keyBoardAction()
    }
    
    //MARK: - Custom Methods
    
    //MARK: - @objc Methods

    //MARK: - IBActions
    
    // TODO: BG 탭했을때, 키보드 내려오게 하기
    @IBAction func tapBG(_ sender: Any) {
        nickNameTextField.resignFirstResponder()
    }
    
    @IBAction func NickTextFieldDidTap(_ sender: Any) {
        /// 최대길이 설정
        checkMaxLength(textField: nickNameTextField, maxLength: 6)
    }
    
    @IBAction func backButtonDidTap(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func changeButtonDidTap(_ sender: Any) {
        
        let alert = UIAlertController(title: "닉네임을 변경 하시겠습니까?", message: "", preferredStyle: UIAlertController.Style.alert)
        let noButton = UIAlertAction(title: "아니요", style: UIAlertAction.Style.default, handler: nil)
        let yesButton = UIAlertAction(title: "네", style: UIAlertAction.Style.default, handler: { _ in        self.navigationController?.popViewController(animated: true)})
        
        alert.addAction(noButton)
        alert.addAction(yesButton)
        
        if changBool == true {
        present(alert, animated: true, completion: nil)
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
            self.changeButton.setImage(UIImage(named: "settingBtnEditUnselected"), for: .normal)
            self.textRadiusImage.image = UIImage(named: "settingImgTextfieldUnselected")
            countLabel.textColor = UIColor.mintIcon
        }else{
            self.changBool = true
            self.changeButton.setImage(UIImage(named: "settingBtnEditSelected"), for: .normal)
            self.textRadiusImage.image = UIImage(named: "settingImgTextfieldSelected")
            countLabel.textColor = UIColor.black
            
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
            changeButtonBottom.constant = adjustemnHeight
        }else {
            changeButtonBottom.constant = 0
        }
    }
}
