//
//  RecordRateCVC.swift
//  Weathy
//
//  Created by DANNA LEE on 2020/12/31.
//

import UIKit

class RecordRateCVC: UICollectionViewCell {
    
    //MARK: - IBOutlets
    
    @IBOutlet var emojiImageView: UIImageView!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var descriptionLabel: UILabel!
    
    func setCell(imageName: String, titleText: String, titleColor: String, description: String) {
        emojiImageView.image = UIImage(named: "\(imageName)")
        
        titleLabel.text = "\(titleText)"
        titleLabel.textColor = UIColor(named: titleColor)
        titleLabel.font = UIFont.SDGothicSemiBold17
        
        descriptionLabel.text = "\(description)"
        descriptionLabel.font = UIFont.SDGothicRegular16
        descriptionLabel.textColor = UIColor.subGrey6
    }
    
}
