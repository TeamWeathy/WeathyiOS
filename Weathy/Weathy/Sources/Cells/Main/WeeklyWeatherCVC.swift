//
//  WeeklyWeatherCVC.swift
//  Weathy
//
//  Created by inae Lee on 2021/01/09.
//

import UIKit

class WeeklyWeatherCVC: UICollectionViewCell {
    //MARK: - Custom Variables
    static let identifier = "WeeklyWeatherCVC"
    
    //MARK: - IBOutlets
    
    @IBOutlet weak var dayOfWeekLabel: SpacedLabel!
    @IBOutlet weak var climateImage: UIImageView!
    @IBOutlet weak var maxTempLabel: SpacedLabel!
    @IBOutlet weak var minTempLabel: SpacedLabel!
    @IBOutlet weak var tempDiffView: UIView!
    
    //MARK: - LifeCycle Methods
    
    //MARK: - Custom Methods
    
    func setCell() {
        dayOfWeekLabel.font = UIFont.SDGothicRegular13
        dayOfWeekLabel.textColor = UIColor.subGrey6
        dayOfWeekLabel.characterSpacing = -0.65
        
        maxTempLabel.font = UIFont.RobotoRegular16
        maxTempLabel.textColor = UIColor.redTemp
        maxTempLabel.characterSpacing = -0.8
        
        minTempLabel.font = UIFont.RobotoRegular16
        minTempLabel.textColor = UIColor.blueTemp
        minTempLabel.characterSpacing = -0.8
        
        tempDiffView.backgroundColor = UIColor.subGrey3
        tempDiffView.makeRounded(cornerRadius: 1)
    }
    
    func setWeeklyWeatherData(data: MainDailyWeather, idx: Int) {
        let dayOfWeek: String = data.date.dayOfWeek
        
        dayOfWeekLabel.text = "\(dayOfWeek.prefix(1))"
        maxTempLabel.text = "\(data.temperature.maxTemp)°"
        minTempLabel.text = "\(data.temperature.minTemp)°"
        climateImage.image = UIImage(named: "ic_snow")
        
        if (idx == 0) {
            dayOfWeekLabel.textColor = UIColor.mintIcon
            dayOfWeekLabel.text = "오늘"
        }
    }
}
