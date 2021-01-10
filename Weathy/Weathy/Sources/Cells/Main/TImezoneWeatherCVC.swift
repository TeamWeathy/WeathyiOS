//
//  TImezoneWeatherCVC.swift
//  Weathy
//
//  Created by inae Lee on 2021/01/09.
//

import UIKit

class TImezoneWeatherCVC: UICollectionViewCell {
    //MARK: - Custom Variables
    
    //MARK: - IBOutlets
    
    @IBOutlet weak var timeLabel: SpacedLabel!
    @IBOutlet weak var climateImage: UIImageView!
    @IBOutlet weak var popLabel: SpacedLabel!
    @IBOutlet weak var temperatureLabel: SpacedLabel!
    
    //MARK: - LifeCycle Methods
    
    //MARK: - Custom Methods
    
    func setCell() {
        timeLabel.text = "18시"
        timeLabel.font = UIFont.SDGothicRegular13
        timeLabel.textColor = UIColor.subGrey6
        timeLabel.characterSpacing = -0.65
        
        climateImage.image = UIImage(named: "ic_fewclouds_day")
        
        popLabel.text = "30%"
        popLabel.font = UIFont.RobotoRegular12
        popLabel.textColor = UIColor.mintIcon
        popLabel.characterSpacing = -0.6
        
        temperatureLabel.text = "-5°"
        temperatureLabel.font = UIFont.RobotoRegular16
        temperatureLabel.textColor = UIColor.subGrey1
        temperatureLabel.characterSpacing = -0.8
    }
}
