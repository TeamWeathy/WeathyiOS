//
//  RecordTagDeletePopupVC.swift
//  Weathy
//
//  Created by DANNA LEE on 2021/01/09.
//

import UIKit

class RecordTagDeletePopupVC: UIViewController {
    
    //MARK: - Custom Variables
    
    var tagCount: Int = 2
    var selectedTags: [Int] = []
    
    var isDeleted: Bool = false
    
    //MARK: - @IBOutlets
    
    @IBOutlet var popupView: UIView!
    @IBOutlet var titleLabel: SpacedLabel!
    @IBOutlet var subTitleLabel: SpacedLabel!
    @IBOutlet var cancelBtn: UIButton!
    @IBOutlet var deleteBtn: UIButton!
    
    //MARK: - Life Cycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setPopUpView()
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func cancelBtnTap(_ sender: Any) {
        self.dismiss(animated: false, completion: nil)
    }
    
    @IBAction func deleteBtnTap(_ sender: Any) {
        
        // 삭제 API 연결
        callDeleteTagService()
        
    }
}

//MARK: - Style

extension RecordTagDeletePopupVC {
    
    func setPopUpView() {
        popupView.makeRounded(cornerRadius: 15)
        
        titleLabel.font = .SDGothicSemiBold20
        titleLabel.textColor = .pink
        titleLabel.text = "\(tagCount)개 태그를 정말 삭제할까요?"
        titleLabel.lineSetting(kernValue: -1.0)
        
        subTitleLabel.font = .SDGothicRegular16
        subTitleLabel.textColor = .subGrey6
        subTitleLabel.text = "삭제하면 되돌릴 수 없어요."
        subTitleLabel.lineSetting(kernValue: -0.8)
        
        /// 송편 되는 문제 해결 - 레이아웃이 변경 됐을 때 반영
        self.view.layoutIfNeeded()
        
        cancelBtn.setBorder(borderColor: .subGrey2, borderWidth: 1)
        cancelBtn.makeRounded(cornerRadius: 25)
        cancelBtn.setTitle("닫기", for: .normal)
        cancelBtn.setTitleColor(UIColor.subGrey6, for: .normal)
        cancelBtn.titleLabel?.font = .SDGothicMedium16
        cancelBtn.titleLabel?.lineSetting(kernValue: -0.8)
        
        deleteBtn.makeRounded(cornerRadius: 25)
        deleteBtn.setTitle("삭제하기", for: .normal)
        deleteBtn.setTitleColor(.white, for: .normal)
        deleteBtn.backgroundColor = .pink
        deleteBtn.titleLabel?.font = .SDGothicSemiBold16
        deleteBtn.titleLabel?.lineSetting(kernValue: -0.8)
        
    }
    
    func callDeleteTagService() {
        RecordTagService.shared.deleteTag(userId: Int(UserDefaults.standard.string(forKey: "userId") ?? "") ?? 0, token: UserDefaults.standard.string(forKey: "token") ?? "", clothArray: selectedTags) { (networkResult) -> (Void) in
            switch networkResult {
            case .success(let data):
//                print(">>> success")
                if let loadData = data as? Closet {
                    self.isDeleted = true
                    self.presentingViewController?.presentingViewController?.dismiss(animated: false) {
                        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "TagDeleted"), object: self.isDeleted)
                    }
                }
                
            case .requestErr(let msg):
                print("requestErr")
                if let message = msg as? String {
                    self.showToast(message: "예기치 못한 오류, 다시 시도하세요.")
                    print(message)
                }
            case .pathErr:
                print("pathErr")
                self.showToast(message: "예기치 못한 오류, 다시 시도하세요.")
            case .serverErr:
                print("serverErr")
                self.showToast(message: "예기치 못한 오류, 다시 시도하세요.")
            case .networkFail:
                print("networkFail")
                self.showToast(message: "예기치 못한 오류, 다시 시도하세요.")
            }
        }
    }
}
