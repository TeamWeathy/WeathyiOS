//
//  RecordTagDeletePopupVC.swift
//  Weathy
//
//  Created by DANNA LEE on 2021/01/09.
//

import UIKit

class RecordTagDeletePopupVC: UIViewController {

    var tagCount: Int = 2
    
    @IBOutlet var popupView: UIView!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var subTitleLabel: UILabel!
    @IBOutlet var cancelBtn: UIButton!
    @IBOutlet var deleteBtn: UIButton!
    
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
        
        self.view.window!.rootViewController?.dismiss(animated: false, completion: nil)
    }
}

//MARK: - Style

extension RecordTagDeletePopupVC {
    
    func setPopUpView() {
        popupView.makeRounded(cornerRadius: 15)
        
        titleLabel.font = .SDGothicSemiBold20
        titleLabel.textColor = .pink
        titleLabel.text = "\(tagCount)개 태그를 정말 삭제할까요?"
        
        subTitleLabel.font = .SDGothicRegular16
        subTitleLabel.textColor = .subGrey6
        subTitleLabel.text = "삭제하면 되돌릴 수 없어요."
        
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
}
