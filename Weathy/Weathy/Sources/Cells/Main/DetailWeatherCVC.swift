//
//  DetailWeatherCVC.swift
//  Weathy
//
//  Created by inae Lee on 2021/01/10.
//

import UIKit

class DetailWeatherCVC: UICollectionViewCell {
    //MARK: - local Variables
    static let identifier = "DetailWeatherCVC"
    
    //MARK: - IBOutlets
    @IBOutlet weak var detailPropertyImage: UIImageView!
    @IBOutlet weak var detailPropertyLabel: SpacedLabel!
    @IBOutlet weak var detailValueLabel: SpacedLabel!
    @IBOutlet weak var detailRatingLabel: SpacedLabel!
    
    //MARK: - Custom Methods
    func setCell() {
        detailPropertyImage.image = UIImage(named: "icRainfall")
        
        detailPropertyLabel.text = "강수량"
        detailPropertyLabel.font = UIFont.SDGothicSemiBold13
        detailPropertyLabel.textColor = UIColor.subGrey6
        detailPropertyLabel.characterSpacing = -0.65
        
        detailValueLabel.text = "보통"
        detailValueLabel.font = UIFont.SDGothicMedium15
        detailValueLabel.textColor = UIColor.subGrey1
        detailValueLabel.characterSpacing = -0.75
        
        detailRatingLabel.text = "12m/s"
        detailRatingLabel.font = UIFont.RobotoRegular11
        detailRatingLabel.textColor = UIColor.subGrey6
        detailRatingLabel.characterSpacing = -0.65
    }
}
