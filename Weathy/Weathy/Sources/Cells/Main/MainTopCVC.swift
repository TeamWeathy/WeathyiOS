//
//  MainTopCell.swift
//  Weathy
//
//  Created by inae Lee on 2021/01/04.
//

import UIKit

class MainTopCVC: UICollectionViewCell {
    //MARK: - Custom Variables
    
    //MARK: - IBOutlets
    @IBOutlet weak var todayWeathyNicknameTextLabel: UILabel!
    @IBOutlet weak var todayWeathyView: UIView!
    @IBOutlet weak var currTemperatureLabel: UILabel!
    @IBOutlet weak var highTemperatureLabel: UILabel!
    @IBOutlet weak var lowTemperatureLabel: UILabel!
    @IBOutlet weak var climateLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var weathyDateLabel: UILabel!
    @IBOutlet weak var weathyClimateImage: UIImageView!
    @IBOutlet weak var weathyClimateLabel: UILabel!
    @IBOutlet weak var weathyHighTemperatureLabel: UILabel!
    @IBOutlet weak var weathyLowTemperatureLabel: UILabel!
    @IBOutlet weak var weathyStampImage: UIImageView!
    @IBOutlet weak var weathyStampLabel: UILabel!
    @IBOutlet weak var closetTopLabel: UILabel!
    @IBOutlet weak var closetBottomLabel: UILabel!
    @IBOutlet weak var closetOuterLabel: UILabel!
    @IBOutlet weak var closetEtcLabel: UILabel!
    
    //MARK: - Custom Methods
    func setCell() {
        todayWeathyNicknameTextLabel.font = UIFont.SDGothicRegular16
        todayWeathyNicknameTextLabel.text = "희지님이 기억하는"
        
        todayWeathyView.makeRounded(cornerRadius: 35)
        todayWeathyView.dropShadow(color: .black, offSet: CGSize(width: 0, height: 10), opacity: 0.21, radius: 50)
        
        locationLabel.text = "서울 서대문구"
        locationLabel.font = UIFont.SDGothicSemiBold20
        locationLabel.textColor = UIColor.mainGrey
        
        currTemperatureLabel.text = "-2°"
        currTemperatureLabel.font = UIFont.RobotoLight60
        currTemperatureLabel.textColor = UIColor.subGrey1
        
        highTemperatureLabel.text = "24°"
        highTemperatureLabel.font = UIFont.RobotoLight25
        highTemperatureLabel.textColor = UIColor.redTemp
        
        lowTemperatureLabel.text = "-14°"
        lowTemperatureLabel.font = UIFont.RobotoLight25
        lowTemperatureLabel.textColor = UIColor.blueTemp
        
        climateLabel.text = "조금 흐리지만\n햇살이 따스해요 :)"
        climateLabel.font = UIFont.SDGothicRegular16
        climateLabel.textColor = UIColor.init(red: 0, green: 0, blue: 0, alpha: 0.58)
        
        weathyDateLabel.text = "2020년 12월 1일"
        weathyDateLabel.font = UIFont.SDGothicRegular13
        weathyDateLabel.textColor = UIColor.subGrey6
        
        weathyClimateImage.image = UIImage(named: "ic_fewclouds_day")
        
        weathyClimateLabel.text = "구름조금"
        weathyClimateLabel.font = UIFont.SDGothicMedium15
        weathyClimateLabel.textColor = UIColor.subGrey1
        
        weathyHighTemperatureLabel.text = "4°"
        weathyHighTemperatureLabel.textColor = UIColor.redTemp
        weathyHighTemperatureLabel.font = UIFont.RobotoLight30

        weathyLowTemperatureLabel.text = "-4°"
        weathyLowTemperatureLabel.textColor = UIColor.blueTemp
        weathyLowTemperatureLabel.font = UIFont.RobotoLight30
        
//        weathyStampImage.image = UIImage(named: <#T##String#>)
        weathyStampLabel.text = "추워요"
        weathyStampLabel.font = UIFont.SDGothicSemiBold23
        weathyStampLabel.textColor = UIColor.imojiColdText
    }
}
