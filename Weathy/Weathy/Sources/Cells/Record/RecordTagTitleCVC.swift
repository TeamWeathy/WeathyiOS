//
//  RecordTagTitleCVC.swift
//  Weathy
//
//  Created by DANNA LEE on 2021/01/01.
//

import UIKit

class RecordTagTitleCVC: UICollectionViewCell {
    
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var countLabel: UILabel!
    @IBOutlet var bottomBarView: UIView!
    
    func setCell(title: String, total: Int, count: Int, isSelected: Bool, isDeleteView: Bool) {
        titleLabel.text = "\(title)"
        titleLabel.font = UIFont.SDGothicRegular18
        titleLabel.textColor = UIColor.mainGrey
        
        bottomBarView.layer.cornerRadius = 1.5
        
        countLabel.font = UIFont.SDGothicRegular15
//        countLabel.textColor = UIColor.subGrey6
        
        if isDeleteView == false {
            countLabel.text = "\(count)/5"
            
            if let text = countLabel.text {
                // "\(group.peopleCount)명" 부분에만 폰트를 다르게 설정
                let attributedStr = NSMutableAttributedString(string: countLabel.text ?? "")
                attributedStr.addAttribute(NSAttributedString.Key(rawValue: kCTFontAttributeName as String),
                                           value: UIFont(name: "AppleSDGothicNeoSB00", size: 15.0)!, range: (text as NSString).range(of: "\(count)"))
                attributedStr.addAttribute(.foregroundColor, value: UIColor.mintIcon, range: (countLabel.text! as NSString).range(of: "\(count)"))
                
                if count >= 1 {
                    countLabel.attributedText = attributedStr
                } else {
                    countLabel.textColor = .subGrey6
                    countLabel.font = .SDGothicRegular15
                }
            }
        }
        else {
            countLabel.text = "\(total)"
        }
        
        if isSelected == true { /// 선택된 카테고리
            titleLabel.textColor = .mainGrey
            
            if isDeleteView == false { /// 기록뷰 선택된 카테고리
                bottomBarView.backgroundColor = UIColor.mintMain
            }
            else { /// 삭제뷰 선택된 카테고리
                bottomBarView.backgroundColor = UIColor.pink
                countLabel.textColor = .subGrey6
            }
        }
        else { /// 선택되지 않은 카테고리
            bottomBarView.backgroundColor = .clear
            
            countLabel.font = .SDGothicRegular15
            countLabel.textColor = .subGrey4
            
            titleLabel.textColor = .subGrey6
        }
    }
}
