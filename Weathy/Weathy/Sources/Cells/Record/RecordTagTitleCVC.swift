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
    
    func setCell(title: String, count: Int, isSelected: Bool) {
        titleLabel.text = "\(title)"
        titleLabel.font = UIFont.SDGothicRegular18
        titleLabel.textColor = UIColor.mainGrey
        
        countLabel.text = "\(count)/5"
        countLabel.font = UIFont.SDGothicRegular15
        countLabel.textColor = UIColor.subGrey6
        
        if isSelected == true {
            bottomBarView.backgroundColor = UIColor.mintMain
            bottomBarView.layer.cornerRadius = 5
        } else {
            bottomBarView.backgroundColor = .clear
        }
    }
}
