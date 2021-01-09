//
//  WeeklyWeatherCVC.swift
//  Weathy
//
//  Created by inae Lee on 2021/01/09.
//

import UIKit

class WeeklyWeatherCVC: UICollectionViewCell {
    //MARK: - Custom Variables
    
    //MARK: - IBOutlets
    
    @IBOutlet weak var dayOfWeekLabel: UILabel!
    @IBOutlet weak var climateImage: UIImageView!
    @IBOutlet weak var maxTempLabel: UILabel!
    @IBOutlet weak var minTempLabel: UILabel!
    @IBOutlet weak var tempDiffView: UIView!
    
    //MARK: - LifeCycle Methods
    
    //MARK: - Custom Methods
    
    func setCell() {
        dayOfWeekLabel.text = "오늘"
        dayOfWeekLabel.font = UIFont.SDGothicRegular13
        dayOfWeekLabel.textColor = UIColor.subGrey6
        
        climateImage.image = UIImage(named: "ic_snow")
        
        maxTempLabel.text = "-1°"
        maxTempLabel.font = UIFont.RobotoRegular16
        maxTempLabel.textColor = UIColor.redTemp
        
        minTempLabel.text = "-18°"
        minTempLabel.font = UIFont.RobotoRegular16
        minTempLabel.textColor = UIColor.blueTemp
        
        tempDiffView.backgroundColor = UIColor.subGrey3
        tempDiffView.makeRounded(cornerRadius: 1)
    }
}
