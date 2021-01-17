//
//  NickNameVC.swift
//  Weathy
//
//  Created by 송황호 on 2021/01/12.
//

import UIKit
import CoreLocation

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
    @IBOutlet weak var totalCountLabel: UILabel!
    
    @IBOutlet weak var changeButton: UIButton!
    @IBOutlet weak var changeButtonBottom: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        countLabel.text = "\(textCount)"
        clearButton.isHidden = true
        nickNameTextField.delegate = self
        
//        let delegate = UIApplication.shared.delegate! as! AppDelegate
//        var locationManager = delegate.locationManager
//        locationManager.delegate = self
//        //    locationManager.requestWhenInUseAuthorization()
//        locationManager.desiredAccuracy = kCLLocationAccuracyBest
//        locationManager.startUpdatingLocation()
//        print("$$",UserDefaults.standard.string(forKey: "authoriz $ation"))
        
        //MARK: - LifeCycle Methods
        
        labelFontSetting()
        keyBoardAction()
    }
    
    //MARK: - Custom Methods
    
    func labelFontSetting(){
        nickLabel.font = UIFont.SDGothicSemiBold25
        sentenceLabel.font = UIFont.SDGothicRegular16
        countLabel.font = UIFont.SDGothicRegular13
        countLabel.textColor = UIColor.subGrey6
        totalCountLabel.font = UIFont.SDGothicRegular13
        totalCountLabel.textColor = UIColor.subGrey6
        sentenceLabel.textColor = UIColor.subGrey6
        
        let attr = NSMutableAttributedString(string: nickLabel.text!)
        attr.addAttribute(NSAttributedString.Key.foregroundColor,
                          value: UIColor.mintIcon, range: (nickLabel.text! as NSString).range(of: "닉네임")) // 글자 색깔
        nickLabel.attributedText = attr
    }
    
    /// 변경하기 aleart  생성
    func simpleAlert() {
        let alert = UIAlertController(title: "닉네임을 설정 하시겠습니까?", message: "", preferredStyle: UIAlertController.Style.alert)
        let noButton = UIAlertAction(title: "아니요", style: UIAlertAction.Style.default, handler: nil)
        let yesButton = UIAlertAction(title: "네", style: UIAlertAction.Style.default, handler: { _ in
//                UserDefaults.standard.set(true, forKey: "onboarding")
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
            self.changeButton.setBackgroundImage(UIImage(named: "nickname_btn_start"), for: .normal)
            self.textRadiusImage.image = UIImage(named: "settingImgTextfieldUnselected")
            countLabel.textColor = UIColor.subGrey6
            countLabel.text = "0"
            nickNameTextField.text = ""
        }
    }
    
    /// 변경하기 눌렀을 때 서버 연결 코드
    @IBAction func changeButtonDidTap(_ sender: Any) {
        
        guard let nickName = nickNameTextField.text else { return }
        
//         let uuid = UUID().uuidString
        let uuid = "010-8966-1467"
        UserDefaults.standard.set("웨요", forKey: "nickname")
                            UserDefaults.standard.set("50:17bPiTmEBstqZjwCimtjfwtSnZk2OR", forKey: "token")
                            UserDefaults.standard.set(50, forKey: "userId")
                            UserDefaults.standard.set("010-8966-1467", forKey: "UUID")
//        let UUID : String = UUID().
        /// 서버 연결!
        if self.changBool == true {
            self.simpleAlert()
        }
//        createUserService.shared.createUserPost(uuid: uuid, nickname: nickName){(NetworkResult) -> (Void) in
//            switch NetworkResult{
//            case .success(let data):
//
//                if let createData = data as? UserInformation {
////                    UserDefaults.standard.set(createData.user.nickname, forKey: "nickname")
////                    UserDefaults.standard.set(createData.token, forKey: "token")
////                    UserDefaults.standard.set(createData.user.id, forKey: "userId")
////                    UserDefaults.standard.set(uuid, forKey: "UUID")
//
////                    print("userID ---> \(UserDefaults.standard.string(forKey: "userID"))")
////                    print("token ---> \(UserDefaults.standard.string(forKey: "token"))")
//
////                    print("---> 뭐니 넌\(self.changBool)")
//                    /// 닉네임 설정 했을 때 aleart 띄우기
//                    if self.changBool == true {
//                        self.simpleAlert()
//                    }
//                }
//            case .requestErr:
//                print("requestErr")
//            case .pathErr:
//                print("pathErr")
//            case .serverErr:
//                print("serverErr")
//            case .networkFail:
//                print("networkFail")
//            }
//        }
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
            self.changeButton.setBackgroundImage(UIImage(named: "nickname_btn_start"), for: .normal)
            self.textRadiusImage.image = UIImage(named: "settingImgTextfieldUnselected")
            clearButton.isHidden = true
            countLabel.textColor = UIColor.subGrey6
        }else{
            self.changBool = true
            self.changeButton.setBackgroundImage(UIImage(named: "nickname_btn_start_mint"), for: .normal)
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
            changeButtonBottom.constant = 16
        }
    }
}

extension NickNameVC: CLLocationManagerDelegate{
     
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
          let location: CLLocation = locations[locations.count - 1]
          let longitude: CLLocationDegrees = location.coordinate.longitude
          let latitude: CLLocationDegrees = location.coordinate.latitude
          let findLocation: CLLocation = CLLocation(latitude: latitude, longitude: longitude)
          let geoCoder: CLGeocoder = CLGeocoder()
        let local: Locale = Locale(identifier: "Ko-kr") // Korea
          geoCoder.reverseGeocodeLocation(findLocation, preferredLocale: local) { (place, error) in
            if let address: [CLPlacemark] = place {
              let state = (address.last?.administrativeArea)!
              let city = (address.last?.locality)!
                print("(longitude, latitude) = (\(longitude), \(latitude))")
              print("시(도):",state)
              print("구(군):",city)
            }
          }
        }
      ///Change
      func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        print("Change")
      }
}
