//
//  TImezoneWeatherCVC.swift
//  Weathy
//
//  Created by inae Lee on 2021/01/09.
//

import UIKit

class TimezoneWeatherCVC: UICollectionViewCell {
    // MARK: - Custom Variables

    static let idenfier = "TimezoneWeatherCVC"
    
    // MARK: - IBOutlets
    
    @IBOutlet var timeLabel: SpacedLabel!
    @IBOutlet var climateImage: UIImageView!
    @IBOutlet var popLabel: SpacedLabel!
    @IBOutlet var temperatureLabel: SpacedLabel!
    
    // MARK: - LifeCycle Methods
    
    // MARK: - Custom Methods
    
    func setCell() {
        timeLabel.font = UIFont.SDGothicRegular13
        timeLabel.textColor = UIColor.subGrey6
        timeLabel.characterSpacing = -0.65
        
        popLabel.font = UIFont.RobotoRegular12
        popLabel.textColor = UIColor.mintIcon
        popLabel.characterSpacing = -0.6
        
        temperatureLabel.font = UIFont.RobotoRegular16
        temperatureLabel.textColor = UIColor.subGrey1
        temperatureLabel.characterSpacing = -0.8
    }
    
    func setTimezoneWeatherData(hourlyData: HourlyWeather, idx: Int) {
        if let time = hourlyData.time,
           let temp = hourlyData.temperature
        {
            timeLabel.alpha = 1
            timeLabel.text = "\(time)"
            temperatureLabel.text = "\(temp)°"
        }
        climateImage.image = UIImage(named: ClimateImage.getClimateIconName(hourlyData.climate.iconId))
        popLabel.text = "\(hourlyData.pop)%"
        
        if idx == 0 {
            timeLabel.text = "●"
            timeLabel.textColor = UIColor.mintMain
        }
    }
    
    /// not used
    func scrollUpAnimation() {
        popLabel.transform = CGAffineTransform(translationX: 0, y: -5)
        
        UIView.animate(withDuration: 0.8, delay: 1) {
            self.popLabel.alpha = 0
            self.popLabel.transform = .identity
            self.popLabel.alpha = 1
        }
    }
}
