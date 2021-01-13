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
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var subTitleLabel: UILabel!
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
        RecordTagService.shared.deleteTag(userId: 63, token: "63:wckgTPK2NtG7JoM0p207XwsmDxOmM7", clothArray: selectedTags) { (networkResult) -> (Void) in
            switch networkResult {
            case .success(let data):
                print(">>> success")
                if let loadData = data as? ClothesTagData {
                    self.isDeleted = true
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "TagDeleted"), object: self.isDeleted)
                    self.view.window!.rootViewController?.dismiss(animated: false, completion: nil)
                    //                    self.presentingViewController?.viewWillAppear(false)
                }
                
            case .requestErr(let msg):
                print("requestErr")
                if let message = msg as? String {
                    print(message)
                }
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
