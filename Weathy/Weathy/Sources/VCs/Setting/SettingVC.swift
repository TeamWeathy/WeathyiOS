//
//  SettingVC.swift
//  Weathy
//
//  Created by 송황호 on 2021/01/04.
//

import UIKit

class SettingVC: UIViewController {
    // MARK: - Custom Variables
    
    let feedbackEmail = "weathycrew@gmail.com"
    let privacyURL = "https://www.notion.so/5a2f164b5afe46559c78d7efed6d3e8a"
    let locationURL = "https://www.notion.so/69010f5bca1e443ca3b47cfd74bdb41f"
    let openSourceURL = ""
    let feedbackSubject = "Weathy 문의 및 건의하기"
    let feedbackBody = ""
    
    // MARK: - IBOutlets
    
    @IBOutlet var settingTitleLabel: SpacedLabel!
    @IBOutlet var buttonLabels: [SpacedLabel]!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setFontColor()
        
        NotificationCenter.default.addObserver(self, selector: #selector(showChangedNicknameToast), name: NSNotification.Name("changeNickname"), object: nil)
    }
    
    // MARK: - Custom Methods
    
    func setFontColor() {
        settingTitleLabel.font = UIFont.SDGothicSemiBold25
        settingTitleLabel.textColor = UIColor.mainGrey
        settingTitleLabel.characterSpacing = -1.25
        
        for i in 0 ..< buttonLabels.count {
            buttonLabels[i].font = UIFont.SDGothicRegular16
            buttonLabels[i].characterSpacing = -0.8
            buttonLabels[i].textColor = UIColor.mainGrey
        }
    }
    
    func createEmailUrl(to: String, subject: String, body: String) -> String {
        let subjectEncoded = subject.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        let bodyEncoded = body.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        
        let defaultUrl = "mailto:\(to)?subject=\(subjectEncoded)&body=\(bodyEncoded)"
        
        return defaultUrl
    }
    
    func openURL(urlString: String) {
        if let url = URL(string: "\(urlString)") {
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(url)
            }
            else {
                UIApplication.shared.openURL(url)
            }
        }
    }
    
    // MARK: - @objc Methods

    @objc func showChangedNicknameToast(_ noti: NSNotification) {
        showToast(message: "닉네임이 변경되었어요.")
    }
    
    // MARK: - IBActions

    @IBAction func backButtonDidTap(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }

    @IBAction func feedbackButtonDidTap(_ sender: Any) {
        let email = createEmailUrl(to: feedbackEmail, subject: feedbackSubject, body: feedbackBody)
        openURL(urlString: email)
    }

    @IBAction func privacyButtonDidTap(_ sender: Any) {
        openURL(urlString: privacyURL)
    }

    @IBAction func locationButtonDidTap(_ sender: Any) {
        openURL(urlString: locationURL)
    }

    @IBAction func openSourceButtonDidTap(_ sender: Any) {
        guard let openSourceVC = storyboard?.instantiateViewController(identifier: "SettingOpenSourceVC") as? SettingOpenSourceVC else { return }
        navigationController?.pushViewController(openSourceVC, animated: true)
    }
}
