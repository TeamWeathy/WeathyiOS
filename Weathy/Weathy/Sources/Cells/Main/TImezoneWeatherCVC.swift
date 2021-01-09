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
    
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var climateImage: UIImageView!
    @IBOutlet weak var popLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    
    //MARK: - LifeCycle Methods
    
    //MARK: - Custom Methods
    
    func setCell() {
        timeLabel.text = "18시"
        timeLabel.font = UIFont.SDGothicRegular13
        timeLabel.textColor = UIColor.subGrey6
        
        climateImage.image = UIImage(named: "ic_fewclouds_day")
        
        popLabel.text = "30%"
        popLabel.font = UIFont.RobotoRegular12
        popLabel.textColor = UIColor.mintIcon
        
        temperatureLabel.text = "-5°"
        temperatureLabel.font = UIFont.RobotoRegular16
        temperatureLabel.textColor = UIColor.subGrey1
    }
}
