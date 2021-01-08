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
        
        countLabel.font = UIFont.SDGothicRegular15
        countLabel.textColor = UIColor.subGrey6
        
        if isDeleteView == false {
            countLabel.text = "\(count)/5"
        }
        else {
            countLabel.text = "\(total)"
        }
        
        if isSelected == true {
            bottomBarView.layer.cornerRadius = 5
            if isDeleteView == false {
                bottomBarView.backgroundColor = UIColor.mintMain
            }
            else {
                bottomBarView.backgroundColor = UIColor.pink
            }
        }
        else {
            bottomBarView.backgroundColor = .clear
        }
    }
}
