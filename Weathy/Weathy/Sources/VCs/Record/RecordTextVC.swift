//
//  RecordText.swift
//  Weathy
//
//  Created by DANNA LEE on 2020/12/31.
//

import UIKit

class RecordTextVC: UIViewController {
    
    //MARK: - Custom Variables
    
    var dateString: String = "0000-00-00"
    var locationCode: CLong = -1
    
    var selectedTags: [Int] = []
    var selectedStamp: Int = -1
    
    let placeholder: String = "미래의 나에게 들려주고 싶은 날씨 조언을 적어주세요. (예 : 목도리를 챙길걸 그랬어.)"
    let maxWordCount: Int = 100
    var wordCount: Int = 0
    
    var enteredText: String?
    
    let appDelgate: AppDelegate = UIApplication.shared.delegate as! AppDelegate
    
    let picker = UIImagePickerController()
    
    
    //MARK: - IBOutlets
    
    @IBOutlet var skipBtn: UIButton!
    @IBOutlet var skipBtnUnderlineView: UIView!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var subTitleLabel: UILabel!
    @IBOutlet var textTitleLabel: UILabel!
    @IBOutlet var textViewSurroundingView: UIView!
    @IBOutlet var recordTextView: UITextView!
    @IBOutlet var wordCountLabel: UILabel!
    @IBOutlet var maxWordLabel: SpacedLabel!
    @IBOutlet var photoTitleLabel: UILabel!
    @IBOutlet var photoView: UIView!
    @IBOutlet var photoBtn: UIButton!
    @IBOutlet var photoImageView: UIImageView!
    @IBOutlet var finishBtn: UIButton!
    @IBOutlet var optionImageView: [UIImageView]!
    
    //MARK: - LifeCycle Methods

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpper()
        setTitleLabel()
        setTextField()
        textViewSetupView()
        setFinishBtn()
        setSkipBtn()
        setPhotoBox()
        
        
        recordTextView.delegate = self
        
        picker.delegate = self
//        recordTextView.addTarget(self, action: #selector(textViewDidChange(sender:)),for: .editingChanged)
//        recordTextView.add
        
        finishBtn.isUserInteractionEnabled = false
        finishBtn.backgroundColor = UIColor.subGrey3
        finishBtn.setTitle("내용 추가하기", for: .normal)
        finishBtn.setTitleColor(.white, for: .normal)
        finishBtn.layer.cornerRadius = 30
        finishBtn.titleLabel?.font = .SDGothicSemiBold16
        
        textViewSurroundingView.layer.borderColor = UIColor.subGrey7.cgColor
        textViewSurroundingView.layer.borderWidth = 1
        textViewSurroundingView.layer.cornerRadius = 15
        
        wordCountLabel.text = "0"
        wordCountLabel.font = UIFont.SDGothicRegular13
        wordCountLabel.textColor = UIColor.subGrey6
        
        if dateString == "0000-00-00" {
            if let date = appDelgate.overviewData {
                dateString = "\(date.dailyWeather.date.year!)-\(String(format: "%02d", date.dailyWeather.date.month))-\(String(format: "%02d", date.dailyWeather.date.day))"
            }
        }

        print(">>>>>", dateString)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        animationPrac()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    
    //MARK: - IBActions
    
    @IBAction func cameraBtnTap(_ sender: Any) {
        let alert =  UIAlertController(title: "사진 추가하기", message: nil, preferredStyle: .actionSheet)
        
        
        let library =  UIAlertAction(title: "앨범에서 사진 선택", style: .default) { (action) in self.openLibrary()
        }
        
        
        let camera =  UIAlertAction(title: "카메라 촬영", style: .default) { (action) in
            self.openCamera()
        }
        
        
        let cancel = UIAlertAction(title: "취소", style: .cancel, handler: nil)
        
        
        alert.addAction(library)
        alert.addAction(camera)
        alert.addAction(cancel)
        present(alert, animated: true, completion: nil)
        
    }
    
    @IBAction func backBtnTap(_ sender: Any) {
        self.presentingViewController?.presentingViewController?.dismiss(animated: true) {
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "RecordUpdated"), object: 0)
        }
    }
    
    @IBAction func nextBtnTap(_ sender: Any) {
        callModifyWeathyService()
    }
    
    //MARK: - @objc methods
    
    @objc func textViewDidChange(sender:UITextView) {
        
        if let text = sender.text {
            // 초과되는 텍스트 제거
            print(text)
            
        }
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
        
        subTitleLabel.text = "이 웨디는 비슷한 날씨에 나에게 돌아와요."
        subTitleLabel.font = UIFont(name: "AppleSDGothicNeoR00", size: 16)
        subTitleLabel.textColor = UIColor.subGrey6
    }
    
    func setTitleLabel() {
        let attributedString = NSMutableAttributedString(string: "등록이 완료되었어요!\n더 추가할 내용이 있나요?", attributes: [
            .font: UIFont(name: "AppleSDGothicNeoR00", size: 25.0)!,
            .foregroundColor: UIColor.mainGrey,
            .kern: -1.25
        ])
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 4
        attributedString.addAttribute(NSAttributedString.Key.paragraphStyle, value: paragraphStyle, range: NSMakeRange(0, attributedString.length))
        
        attributedString.addAttributes([
            .font: UIFont(name: "AppleSDGothicNeoSB00", size: 25.0)!,
            .foregroundColor: UIColor.mintIcon
        ], range: NSRange(location: 0, length: 6))
        
        titleLabel.attributedText = attributedString
    }
    
    func setTextField() {
        

        
        optionImageView[0].image = UIImage(named: "icOption")
        
        recordTextView.font = UIFont(name: "AppleSDGothicNeoR00", size: 16)
        
//        wordCountLabel.text = "\(wordCount)/\(maxWordCount)"
//        wordCountLabel.font = UIFont.SDGothicRegular13
//        wordCountLabel.textColor = UIColor.subGrey6
        
        maxWordLabel.font = UIFont.SDGothicRegular13
        maxWordLabel.textColor = UIColor.subGrey6
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
    
    func setSkipBtn() {
        
        textTitleLabel.text = "텍스트"
        textTitleLabel.font = UIFont(name: "AppleSDGothicNeoSB", size: 14)
        textTitleLabel.textColor = .subGrey1
        
        skipBtn.setTitle("건너뛰기", for: .normal)
        skipBtn.setTitleColor(.subGrey2, for: .normal)
        skipBtn.titleLabel?.font = UIFont(name: "AppleSDGothicNeoSB00", size: 14)
        
        skipBtnUnderlineView.backgroundColor = .subGrey2
        
    }
    
    func setPhotoBox() {
        optionImageView[1].image = UIImage(named: "icOption")
        
        photoTitleLabel.text = "사진"
        photoTitleLabel.font = UIFont(name: "AppleSDGothicNeoSB", size: 14)
        photoTitleLabel.textColor = .subGrey1
        
        photoView.setBorder(borderColor: .subGrey7, borderWidth: 1)
        photoView.makeRounded(cornerRadius: 13)

    }
    
    func setFinishBtn() {
        finishBtn.backgroundColor = UIColor.lightGray
        finishBtn.setTitle("내용 추가하기", for: .normal)
        finishBtn.setTitleColor(.white, for: .normal)
        finishBtn.layer.cornerRadius = 30
    }
    
    func textExists() {
        finishBtn.isUserInteractionEnabled = true
        UIView.animate(withDuration: 0.5, animations: {
            self.finishBtn.backgroundColor = UIColor.mintMain
            self.finishBtn.setTitle("내용 추가하기", for: .normal)
            self.finishBtn.setTitleColor(.white, for: .normal)
            self.finishBtn.layer.cornerRadius = 30
            self.finishBtn.titleLabel?.font = .SDGothicSemiBold16
        })
        
        textViewSurroundingView.layer.borderColor = UIColor.mintMain.cgColor
        textViewSurroundingView.layer.borderWidth = 1
        textViewSurroundingView.layer.cornerRadius = 15
        
        wordCountLabel.font = UIFont.SDGothicSemiBold13
        wordCountLabel.textColor = UIColor.mintMain
    }
    
    func textNotExists() {
        finishBtn.isUserInteractionEnabled = false
        UIView.animate(withDuration: 0.5, animations: {
            self.finishBtn.backgroundColor = UIColor.subGrey3
            self.finishBtn.setTitle("내용 추가하기", for: .normal)
            self.finishBtn.setTitleColor(.white, for: .normal)
            self.finishBtn.layer.cornerRadius = 30
            self.finishBtn.titleLabel?.font = .SDGothicSemiBold16
        })
        textViewSurroundingView.layer.borderColor = UIColor.subGrey7.cgColor
        textViewSurroundingView.layer.borderWidth = 1
        textViewSurroundingView.layer.cornerRadius = 15
        
        wordCountLabel.text = "0"
        wordCountLabel.font = UIFont.SDGothicRegular13
        wordCountLabel.textColor = UIColor.subGrey6
    }
    
    func initPosition() {
        
        titleLabel.alpha = 0
        titleLabel.frame = CGRect(x: titleLabel.frame.origin.x, y: titleLabel.frame.origin.y-10, width: titleLabel.frame.width, height: titleLabel.frame.height)
        
        subTitleLabel.alpha = 0
        subTitleLabel.frame = CGRect(x: subTitleLabel.frame.origin.x, y: subTitleLabel.frame.origin.y-10, width: subTitleLabel.frame.width, height: subTitleLabel.frame.height)
        
    }
    
    func animationPrac() {
        self.initPosition()
        
        UIView.animate(withDuration: 1, animations: {
            self.titleLabel.alpha = 1
            self.titleLabel.frame = CGRect(x: self.titleLabel.frame.origin.x, y: self.titleLabel.frame.origin.y+10, width: self.titleLabel.frame.width, height: self.titleLabel.frame.height)
        })
        
        UIView.animate(withDuration: 1, delay: 0.5, animations: {
            self.subTitleLabel.alpha = 1
            self.subTitleLabel.frame = CGRect(x: self.subTitleLabel.frame.origin.x, y: self.subTitleLabel.frame.origin.y+10, width: self.subTitleLabel.frame.width, height: self.subTitleLabel.frame.height)
        })
    }
    
    func callModifyWeathyService() {
//        ModifyWeathyService.shared.modifyWeathy(userId: UserDefaults.standard.integer(forKey: "userId"), token: UserDefaults.standard.string(forKey: "token")!, date: dateString, code: locationCode, clothArray: selectedTags, stampId: selectedStamp, feedback: enteredText ?? "", weathyId: weathyData?.weathyId ?? -1) { (networkResult) -> (Void) in
//            print(self.weathyData?.weathyId ?? -1)
//            switch networkResult {
//            case .success(let data):
//                if let loadData = data as? RecordWeathyData {
//                    print(loadData)
//                }
//                self.dismiss(animated: true) {
//                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "RecordUpdated"), object: 1)
//                }
////                self.showToast(message: "웨디에 내용이 추가되었어요!")
//
//            case .requestErr(let msg):
//                print("requestErr")
//                if let message = msg as? String {
//                    print(message)
//                    self.showToast(message: message)
//                }
//
//            case .pathErr:
//                print("pathErr")
//            case .serverErr:
//                print("serverErr")
//            case .networkFail:
//                print("networkFail")
//            }
//        }
    }
    
    func openLibrary() {
        print("library selected")
        
        picker.sourceType = .photoLibrary
        picker.allowsEditing = true
        
        present(picker, animated: false, completion: nil)
        
    }
    
    func openCamera() {
        
        if(UIImagePickerController .isSourceTypeAvailable(.camera)){
            picker.sourceType = .camera
            picker.allowsEditing = true
            present(picker, animated: false, completion: nil)
        }

        else{
            showToast(message: "현재 카메라를 사용할 수 없습니다.")
        }
        
        print("camera selected")
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
            textView.resignFirstResponder()
        }
        
        return true
    }

    func textViewShouldEndEditing(_ textView: UITextView) -> Bool {
        textView.resignFirstResponder()
        return true
    }
    
    func textViewDidChange(_ textView: UITextView) {
        
        if(textView.text.count > maxWordCount) {
            textView.deleteBackward()
        }
        
        self.enteredText = textView.text
        self.wordCount = Int(textView.text.count)
        wordCountLabel.text = "\(wordCount)"

        if textView.text.count == 0 {
            self.textNotExists()
        }else{
            self.textExists()
        }
    }
    
}

//MARK: - UIImagePickerControllerDelegate

extension RecordTextVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            photoImageView.image = image
            print(info)
        }
        
        dismiss(animated: true, completion: nil)
        
    }
    
}
