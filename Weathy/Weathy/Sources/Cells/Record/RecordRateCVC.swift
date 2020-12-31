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
        titleLabel.font = UIFont(name: "AppleSDGothicNeoSB00", size: 17)
        
        descriptionLabel.text = "\(description)"
        descriptionLabel.font = UIFont(name: "AppleSDGothicNeoR00", size: 16)
        descriptionLabel.textColor = UIColor.lightGray
    }
    
}
