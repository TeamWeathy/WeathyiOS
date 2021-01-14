//
//  TImezoneWeatherCVC.swift
//  Weathy
//
//  Created by inae Lee on 2021/01/09.
//

import UIKit

class TimezoneWeatherCVC: UICollectionViewCell {
    //MARK: - Custom Variables
    static let idenfier = "TimezoneWeatherCVC"
    
    //MARK: - IBOutlets
    
    @IBOutlet weak var timeLabel: SpacedLabel!
    @IBOutlet weak var climateImage: UIImageView!
    @IBOutlet weak var popLabel: SpacedLabel!
    @IBOutlet weak var temperatureLabel: SpacedLabel!
    @IBOutlet weak var scrollNowImage: UIImageView!
    
    //MARK: - LifeCycle Methods
    
    //MARK: - Custom Methods
    
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

        scrollNowImage.image = UIImage(named: "mainscrollIcNow")
        scrollNowImage.alpha = 0
    }
    
    func setTimezoneWeatherData(hourlyData: MainHourlyWeather, idx: Int) {
        timeLabel.alpha = 1
        timeLabel.text = "\(hourlyData.time!)"
        scrollNowImage.alpha = 0
        climateImage.image = UIImage(named: "ic_fewclouds_day")
        popLabel.text = "\(hourlyData.pop)%"
        temperatureLabel.text = "\(hourlyData.temperature!)°"
        
        if (idx == 0) {
            scrollNowImage.alpha = 1
            timeLabel.alpha = 0
        }
    }
}
